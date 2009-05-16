Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZEPMHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZEPMHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 08:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZEPMHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 08:07:39 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:50409 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZEPMHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 08:07:38 -0400
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090503215615.GA1368@ucw.cz>
	<200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp>
	<200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp>
	<200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.00.0905151146320.5937@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org>
Message-Id: <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 16 May 2009 21:07:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 14 May 2009, Tetsuo Handa wrote:
> 
> > ---
> >  security/tomoyo/common.c   |  456 +++++++++++++++++++-----------------
> >  security/tomoyo/common.h   |  134 ++++++++--
> >  security/tomoyo/domain.c   |  437 +++++++++++++---------------------
> >  security/tomoyo/file.c     |  369 +++++++++++++++--------------
> >  security/tomoyo/realpath.c |  567 ++++++++++++++++++++++++++++++++++-----------
> >  security/tomoyo/realpath.h |   25 +
> >  security/tomoyo/tomoyo.c   |   40 +--
> >  security/tomoyo/tomoyo.h   |   13 -
> >  8 files changed, 1190 insertions(+), 851 deletions(-)
> 
> This seems like an awfully large and invasive patch just to add GC support 
> which you didn't originally didn't think was necessary.
> 
> I think it needs review from people outside of your project.

I see. Would somebody please review?

For reviewers help, here is my thinking.



As of #15's posting ( http://lkml.org/lkml/2009/2/5/61 ), I was not aware that
use of kmalloc(GFP_KERNEL) with a lock held is not preferable.

For example, 2.6.30-rc6/security/tomoyo/tomoyo.c has below code.

  static int tomoyo_update_single_path_acl(const u8 type, const char *filename,
  					 struct tomoyo_domain_info *
  					 const domain, const bool is_delete)
  {
  	...(snipped)...
  	/***** EXCLUSIVE SECTION START *****/
  	down_write(&tomoyo_domain_acl_info_list_lock);
  	if (is_delete)
  		goto delete;
  	list_for_each_entry(ptr, &domain->acl_info_list, list) {
  		...(snipped)...
  		error = 0;
  		goto out;
  	}
  	/* Not found. Append it to the tail. */
  	acl = tomoyo_alloc_acl_element(TOMOYO_TYPE_SINGLE_PATH_ACL);
  	if (!acl)
  		goto out;
  	...(snipped)...
  	list_add_tail(&acl->head.list, &domain->acl_info_list);
  	error = 0;
  	goto out;
   delete:
  	...(snipped)...
   out:
  	up_write(&tomoyo_domain_acl_info_list_lock);
  	/***** EXCLUSIVE SECTION END *****/
  	return error;
  }

tomoyo_alloc_acl_element() (which calls kmalloc(GFP_KERNEL)) is called with
tomoyo_domain_acl_info_list_lock lock held. And that lock is used like

  static int tomoyo_check_single_path_acl2(const struct tomoyo_domain_info *
  					 domain,
  					 const struct tomoyo_path_info *
  					 filename,
  					 const u16 perm,
  					 const bool may_use_pattern)
  {
    	...(snipped)...
  	down_read(&tomoyo_domain_acl_info_list_lock);
  	list_for_each_entry(ptr, &domain->acl_info_list, list) {
  	  	...(snipped)...
  		error = 0;
  		break;
  	}
  	up_read(&tomoyo_domain_acl_info_list_lock);
  	return error;
  }

This means that when we update TOMOYO's policy (via learning mode or via
/sys/kernel/security/tomoyo/ interface) we might experience a situation where
multiple processes are sleeping for undefined duration if one process went into
sleep state at kmalloc(GFP_KERNEL) in tomoyo_alloc_acl_element() and then
another process went into sleep state at down_read() in
tomoyo_check_single_path_acl2() because of down_write().

This is not a dead lock, but is not preferable.
Away from the discussion whether TOMOYO needs GC or not,
I think TOMOYO should not block reader processes for undefined duration.



TOMOYO will not block reader processes for undefined duration if we call
tomoyo_alloc_acl_element() before down_write(), but that memory will remain
unused if that memory was not added to the list. We cannot release memory
allocated by tomoyo_alloc_acl_element() because tomoyo_alloc_acl_element()
returns requested memory from memory block obtained by kmalloc(PATH_MAX).
tomoyo_alloc_acl_element() is good for minimizing memory usage, but is not
good for releasing unused memory.

TOMOYO will not block reader processes for undefined duration if a writer
process allocates memory before down_write() and releases after up_write()
if the allocated memory was not added to the list.
Thus, I replaced tomoyo_alloc_acl_element() with kmalloc()/kfree() in this
patch. And now, the only reason TOMOYO cannot release memory is that TOMOYO
cannot determine whether memory allocated by kmalloc() is referred by
other processes or not.

Since I replaced tomoyo_alloc_acl_element() with kmalloc()/kfree()
(in order to avoid sleeping operations within a semaphore protected code),
I think TOMOYO is now likely to be able to have GC support (and I also
included the GC in this patch).
