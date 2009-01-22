Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbZAVXl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbZAVXl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbZAVXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:41:46 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:35599 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbZAVXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ciHrbPPs0s+TMLiffhfu+DJoHcqsnw5dg2B6puCyUmzlxFaolFG9gveij0tOeZBDSq
         Ej5RDjno0MD3yEMDgOhlLXWNYBa0lkVWgkfnPkbLPNoLq0OlKMaBv9wj4kppJtkUtnzg
         9XBJvR249yREDmJDIuzo0IiZ+psezhsomJRqY=
MIME-Version: 1.0
In-Reply-To: <20090122183115.1cef1b53@tleilax.poochiereds.net>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
	 <20090122210655.GA6065@infradead.org>
	 <524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com>
	 <20090122183115.1cef1b53@tleilax.poochiereds.net>
Date: Thu, 22 Jan 2009 17:41:43 -0600
Message-ID: <524f69650901221541x63ae3940oaaa75f12a3e2ff97@mail.gmail.com>
Subject: Re: [linux-cifs-client] [PATCH] cifs: wrap cifs_dnotify_thread in 
	CONFIG_BROKEN
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IIRC ... the original suggestion that was made and partially
implemented a few years ago (code was disabled at runtime, not just
wrapped in an ifdef originally) was that cifs_demultiplex_thread would
take the incoming responses from the server for cifs multishot notify
smbs and queue them to a dnotify queue.   The cifs dnotify thread was
inteneded to -- only -- process the items in the dnotify queue, parse
the response to see which of the inline worker functions (in
include/linux/fsnotify.h e.g. fsnotify_create) ineeds to be called,
check if we have a dnotify or inotify for the corresponding inode and
call the generic hook (e.g. fsnotify_d_move or fsnotify_nameremove or
fsnotify_create etc.).   Adding something like that back in would be
easy enough and wrapping inside an ifdef ... but the people who
understand more about inotify presumably don't know about CIFS or SMB2
etc. so it is not likely to be implemented as one step ... but needs
to be staged in.

On Thu, Jan 22, 2009 at 5:31 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 22 Jan 2009 17:13:37 -0600
> Steve French <smfrench@gmail.com> wrote:
>
>> The thread may be renamed/rewritten etc. - but we badly need to finish
>> the dnotify / inotify code ... removing the start on this that someone
>> wrote in the past isn't getting us any closer to this.
>>
>> dnotify/inotify support was added to Linux in the first place because
>> Samba used it to handle this common operation (it is commonly used by
>> OTHER cifs clients) ... but none of the Linux cluster/network file
>> systems have had time to finish the code ... we need to finish this -
>> the network protocol portion of this is now well documented (and we
>> presumably will need a thread to process the dnotify multishot
>> notification responses so we don't clog up the demultiplex thread
>> waiting on kde and gnoe)
>>
>
> Removing this kthread won't measurably move us farther away from that
> goal either.
>
> It's currently under CONFIG_CIFS_EXPERIMENTAL, which would be fine if
> it actually did something. It doesn't though -- it just wakes up tasks
> that don't need to be woken up.
>
> I have no issue with a kthread that does useful work, but why not remove
> this kthread out of the mainline code for now and just plan to put it
> back when it actually has something useful to do?
>
> The patch that removes it will live in perpetuity in git. It'll be a
> trivial matter to revert it when you're ready to have the kthread do
> real work.
>
> --
> Jeff Layton <jlayton@redhat.com>
>



-- 
Thanks,

Steve
