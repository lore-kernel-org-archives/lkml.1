Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXKXUhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXKXUhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 15:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXKXUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 15:37:19 -0500
Received: from mail.fieldses.org ([66.93.2.214]:40848 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbXKXUhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 15:37:15 -0500
Date: Sat, 24 Nov 2007 15:37:14 -0500
To: Phil Endecott <phil_wueww_endecott@chezphil.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No error when inotify_add_watch(/an/NFS/file)
Message-ID: <20071124203714.GD12864@fieldses.org>
References: <20071124195958.GB12864@fieldses.org> <1195935105978@dmwebmail.japan.chezphil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195935105978@dmwebmail.japan.chezphil.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2007 at 08:11:45PM +0000, Phil Endecott wrote:
> J. Bruce Fields wrote:
>> On Fri, Nov 23, 2007 at 11:20:55PM +0000, Phil Endecott wrote:
>>> Dear Experts,
>>>
>>> NFS doesn't work with inotify (and it looks like it can't, certainly not 
>>> before NFS v4.1).  However, if I give an NFS filename to 
>>> inotify_add_watch(), I don't get an error.
>>>
>>> If it indicated an error in this case then I could easily fall back to 
>>> some sort of polling.  Without an error, I need some other way to detect 
>>> NFS (and any other non-inotify-compatible filesystems).
>>>
>>> Any thoughts?
>>
>> The one reason I can think of that you might want that behavior is if
>> you know you only access a given piece of the filesystem from one client
>> at a time, and you still want inotify to work in that situation.
>
> That's a good point.
>
>> (I'm assuming inotify still notifies you of changes that are made on the same
>> client.)
>
> A quick test suggest that it does.
>
>> But maybe you could handle that case by allowing inotify_add_watch() in
>> the case where the nfs filesystem was mounted with the "nolock" option,
>> and failing it otherwise, and telling people to turn on nolock if
>> they're sure they know what they're doing.
>
> I'm not sure what your rationale for proposing that is, and I don't think 
> it helps in my scenario; a user wants their inotify-using application to 
> "just work", not to be told to "sudo re-mount".

I agree, it doesn't help you much.  But for a user that's stuck with an
application that just refuses to do anything if it can't use inotify,
this would allow them to tell the nfs client, "it's OK to let
applications on this filesystem use inotify, because nobody else writes
to this filesystem."

> I suppose that I just need some way to determine whether I will get all, 
> some, or none of the events that I've asked for.

Right.  So you'd like to know that if an inotify watch is granted, that
means you really are going to get notified about everything (either
because the kernel really does have the required knowledge about every
change, or in the "nfs mounted with nolock case" because the user has
told the kernel it doesn't have to worry about the changes it can't
track).

--b.
