Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZELPyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZELPyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbZELPyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:54:38 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:62230 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbZELPyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <1242142528.31807.80.camel@localhost.localdomain>
References: <20090509143742.GA27663@kroah.com> <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil> 
	<20090511175626.GA4758@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> 
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> 
	<1242142528.31807.80.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 12 May 2009 17:54:17 +0200
Message-ID: <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 17:35, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> I think the issue is that the devtmpfs functions are calling vfs helpers
> to create and unlink the device nodes, and those helpers apply
> permission checks based on the current process' credentials.  I think a
> similar issue arose in sysfs a while ago.  Options are to either bypass
> the vfs helpers to avoid that permission checking for what I think are
> intended to be kernel-internal operations, or to override credentials
> temporarily around the calls to the vfs helpers, ala:
> new_cred = prepare_kernel_cred(NULL);
> old_cred  = override_creds(new_cred);
> rc = vfs_mknod(...);
> revert_creds(old_cred);

Ah, I see. That's probably what stuff like this is for:

 /**
  * lookup_one_noperm - bad hack for sysfs
  * @name:       pathname component to lookup
  * @base:       base directory to lookup from
  *
  * This is a variant of lookup_one_len that doesn't perform any permission
  * checks.   It's a horrible hack to work around the braindead sysfs
  * architecture and should not be used anywhere else.
  *
  * DON'T USE THIS FUNCTION EVER, thanks.
  */
  struct dentry *lookup_one_noperm(const char *name, struct dentry *base)

Thanks,
Kay
