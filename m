Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYJQRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYJQRlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbYJQRlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:41:11 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35767 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYJQRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PiVnaQRDV3/Lbqij4gTc0P5KmStTz1XJ0WnXWiMS3Fyu5xJ0x7EruBfymqFqhmkBCN
         9C4qpLLsw4/nuFQMJQG/6131NHiAM3qvrGAQo+ifNcY8Yv3QrNX6FtoqzwlAT03PwxpJ
         bAd+R6hI1XUOF4oaiyYB2d4Dy8PFPOMBIfkSo=
Message-ID: <524f69650810171041i57ab4466s8cecbdf0268f8417@mail.gmail.com>
Date: Fri, 17 Oct 2008 12:41:07 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [linux-cifs-client] Re: unlink behavior when file is open by other process
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
In-Reply-To: <20081017132714.111e33f9@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>
	 <524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>
	 <20081017132714.111e33f9@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 12:27 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Fri, 17 Oct 2008 10:24:29 -0500
> "Steve French" <smfrench@gmail.com> wrote:
>
>> On Fri, Oct 17, 2008 at 10:09 AM, Steve French <smfrench@gmail.com> wrote:
>> > Even when a file is open by another process, posix allows the file to
>> > be deleted (the file is removed from the namespace and eventually the
>> > data is removed from disk).   Unfortunately due to problems in some
>> > NAS filers/servers this can be hard to implement, and I am not sure
>> > what the "best" behavior is in that case.
>
> My argument is that the primary function of unlink() is to remove a
> filename from the filesystem. If we return success from such a call
> without actually having freed up that filename, then that's a bug. It's
> unfortunate that some servers don't support the calls we need to make
> this work all the time.
The filename will be freed - and the trade off is which breaks fewer apps.
Both open and unlink man pages list plausible return codes but I
am worried that the sequence of file operations open/unlink/close
(I think we see both dbench and connectathon do this IIRC)
is as common a a sequence as open/unlink/create/close
thus we could break more apps your way than leaving it as is.

> We can't however make assumptions about what applications want. We
> could, in principle, fix up the situation where a server does
> open->unlink->create by truncating the old file and pretending that
> it's a new one.
That could corrupt data - the original opener may need that data up
to the moment they close that handle.

> All we can reasonably do is try to have each syscall give us the
> expected end result or an error if it can't be done.
The open syscall is allowed to fail with ETXTBUSY (or even access
denied among other).
Although this type of situation is not common on open, it more common in
open (and create) than on unlink and thus A likely that an app could deal with
an open error than on the unlink that preceeded it.   The other argument
here is that whether or not we allow unlink (when it can be marked for deletion
but not silly renamed) - we have apps that will get the same error on open due
to Windows, MacOS and other non-Linux clients setting the flag (ie open/create
failures for a filename that was marked delete-on-close can still
happen even if we aren't the
ones who set the flag on the file since Windows and various other OS can and do
set this file on the server or remotely)


-- 
Thanks,

Steve
