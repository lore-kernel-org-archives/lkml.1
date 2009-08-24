Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbZHXBfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbZHXBfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZHXBfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:35:03 -0400
Received: from tundra.namei.org ([65.99.196.166]:46907 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZHXBfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:35:01 -0400
Date: Mon, 24 Aug 2009 11:34:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       mschmidt@redhat.com, dhowells@redhat.com, sds@tycho.nsa.gov
Subject: Re: + bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch
 added to -mm tree
In-Reply-To: <20090821155742.GA16842@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0908241134230.21562@tundra.namei.org>
References: <200908202139.n7KLdq6D006632@imap1.linux-foundation.org> <20090821155742.GA16842@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


On Fri, 21 Aug 2009, Serge E. Hallyn wrote:
> Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> > 
> > The patch titled
> >      bsdacct: switch credentials for writing to the accounting file
> > has been added to the -mm tree.  Its filename is
> >      bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > 
> > ------------------------------------------------------
> > Subject: bsdacct: switch credentials for writing to the accounting file
> > From: Michal Schmidt <mschmidt@redhat.com>
> > 
> > When process accounting is enabled, every exiting process writes a log to
> > the account file.  In addition, every once in a while one of the exiting
> > processes checks whether there's enough free space for the log.
> > 
> > SELinux policy may or may not allow the exiting process to stat the fs. 
> > So unsuspecting processes start generating AVC denials just because
> > someone enabled process accounting.
> > 
> > For these filesystem operations, the exiting process's credentials should
> > be temporarily switched to that of the process which enabled accounting,
> > because it's really that process which wanted to have the accounting
> > information logged.
> > 
> > Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> > Acked-by: David Howells <dhowells@redhat.com>
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 
> > Cc: James Morris <jmorris@namei.org>
> > Cc: Serge Hallyn <serue@us.ibm.com>
> > Cc: Stephen Smalley <sds@tycho.nsa.gov>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  kernel/acct.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff -puN kernel/acct.c~bsdacct-switch-credentials-for-writing-to-the-accounting-file kernel/acct.c
> > --- a/kernel/acct.c~bsdacct-switch-credentials-for-writing-to-the-accounting-file
> > +++ a/kernel/acct.c
> > @@ -491,13 +491,17 @@ static void do_acct_process(struct bsd_a
> >  	u64 run_time;
> >  	struct timespec uptime;
> >  	struct tty_struct *tty;
> > +	const struct cred *orig_cred;
> > +
> > +	/* Perform file operations on behalf of whoever enabled accounting */
> > +	orig_cred = override_creds(file->f_cred);
> > 
> >  	/*
> >  	 * First check to see if there is enough free_space to continue
> >  	 * the process accounting system.
> >  	 */
> >  	if (!check_free_space(acct, file))
> > -		return;
> > +		goto out;
> > 
> >  	/*
> >  	 * Fill the accounting struct with the needed info as recorded
> > @@ -578,6 +582,8 @@ static void do_acct_process(struct bsd_a
> >  			       sizeof(acct_t), &file->f_pos);
> >  	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
> >  	set_fs(fs);
> > +out:
> > +	revert_creds(orig_cred);
> >  }
> > 
> >  /**
> > _
> > 
> > Patches currently in -mm which might be from mschmidt@redhat.com are
> > 
> > bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
