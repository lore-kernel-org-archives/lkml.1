Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZEMNfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZEMNfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZEMNfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:35:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54264 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZEMNfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <10761.1242220810@redhat.com>
References: <20090509143742.GA27663@kroah.com> <20090511175626.GA4758@kroah.com> 
	<1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> 
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> 
	<1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> 
	<1242168913.6711.9.camel@poy> <10761.1242220810@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 13 May 2009 15:34:49 +0200
Message-ID: <ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: David Howells <dhowells@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 15:20, David Howells <dhowells@redhat.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> +static struct cred *kern_cred;
>
> Can I suggest that you call your cred pointer dev_cred rather than kern_cred
> so that the naming is consistent with the other globals variables?

Sounds good.

>> +     kern_cred = prepare_kernel_cred(NULL);
>
> If you have no intention of altering the credentials you create, you might
> want to use &init_cred instead of kern_cred.  That said, you might want to
> allocate it and let the security module alter it before you use it.

Ah, didn't know that it was exported. It's the one in
include/linux/init_task.h, right? I'll give that a try.

> Also, Stephen is right, you should probably wrap all your accesses to the VFS
> in your devtmpfs credentials.  For instance, devtmpfs_create_node() calls
> vfs_mkdir() with the process's credentials via create_path() and directly with
> the kern_cred.
>
> What you probably want is:

>               nodename = device_get_nodename(dev, &tmp);
>               if (!nodename)
>                      return -ENOMEM;
>                curr_cred = override_creds(kern_cred);
...
>        out_name:
>                revert_creds(curr_cred);

Yeah, I have exactly that already now.

Thanks,
Kay
