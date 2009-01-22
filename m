Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZAVX4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZAVX4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZAVX4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:56:13 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:45489 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbZAVX4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eMdsTpxYx+EHdUQAhoZJMJSuWIpkgVkJ4QawYrLBh1TdQMBrNNQpEBO76vpJHPRbCs
         A1BxAf6jPbPzdq5+r8jY04MLwiHkS9grIkoMoNv8C111painDAwWQAxSVic5MIaNHJxY
         ls50RO5xmaJNIuwbrmlH3tJtv8pQ56DtyTBSY=
MIME-Version: 1.0
In-Reply-To: <524f69650901221541x63ae3940oaaa75f12a3e2ff97@mail.gmail.com>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
	 <20090122210655.GA6065@infradead.org>
	 <524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com>
	 <20090122183115.1cef1b53@tleilax.poochiereds.net>
	 <524f69650901221541x63ae3940oaaa75f12a3e2ff97@mail.gmail.com>
Date: Thu, 22 Jan 2009 17:56:09 -0600
Message-ID: <524f69650901221556q62726c9fg15d9819dca1248fe@mail.gmail.com>
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

One of the obvious reasons that we could throw away the idea of a cifs
dnotify thread for cifs is if we could guarantee that all of the
functions in include/linux/fsnotify.h are nonblocking.  If the
fsnotify.h worker functions are nonblocking then we could safely
process all of the notify responses in cifs_demultiplex_thread (since
we wouldn't have to queue them) without clogging up response
processing for the socket.   Note that notify responses are unusual -
they don't have an application thread waiting on them ("multishot"
responses) typically (there is only one other type of SMB response
that does not have an application thread associated with it).

On Thu, Jan 22, 2009 at 5:41 PM, Steve French <smfrench@gmail.com> wrote:
> IIRC ... the original suggestion that was made and partially
> implemented a few years ago (code was disabled at runtime, not just
> wrapped in an ifdef originally) was that cifs_demultiplex_thread would
> take the incoming responses from the server for cifs multishot notify
> smbs and queue them to a dnotify queue.   The cifs dnotify thread was
> inteneded to -- only -- process the items in the dnotify queue, parse
> the response to see which of the inline worker functions (in
> include/linux/fsnotify.h e.g. fsnotify_create) ineeds to be called,
> check if we have a dnotify or inotify for the corresponding inode and
> call the generic hook (e.g. fsnotify_d_move or fsnotify_nameremove or
> fsnotify_create etc.).   Adding something like that back in would be
> easy enough and wrapping inside an ifdef ... but the people who
> understand more about inotify presumably don't know about CIFS or SMB2
> etc. so it is not likely to be implemented as one step ... but needs
> to be staged in.
>
> On Thu, Jan 22, 2009 at 5:31 PM, Jeff Layton <jlayton@redhat.com> wrote:
>> On Thu, 22 Jan 2009 17:13:37 -0600
>> Steve French <smfrench@gmail.com> wrote:
>>
>>> The thread may be renamed/rewritten etc. - but we badly need to finish
>>> the dnotify / inotify code ... removing the start on this that someone
>>> wrote in the past isn't getting us any closer to this.
>>>
>>> dnotify/inotify support was added to Linux in the first place because
>>> Samba used it to handle this common operation (it is commonly used by
>>> OTHER cifs clients) ... but none of the Linux cluster/network file
>>> systems have had time to finish the code ... we need to finish this -
>>> the network protocol portion of this is now well documented (and we
>>> presumably will need a thread to process the dnotify multishot
>>> notification responses so we don't clog up the demultiplex thread
>>> waiting on kde and gnoe)
>>>
>>
>> Removing this kthread won't measurably move us farther away from that
>> goal either.
>>
>> It's currently under CONFIG_CIFS_EXPERIMENTAL, which would be fine if
>> it actually did something. It doesn't though -- it just wakes up tasks
>> that don't need to be woken up.
>>
>> I have no issue with a kthread that does useful work, but why not remove
>> this kthread out of the mainline code for now and just plan to put it
>> back when it actually has something useful to do?
>>
>> The patch that removes it will live in perpetuity in git. It'll be a
>> trivial matter to revert it when you're ready to have the kthread do
>> real work.
>>
>> --
>> Jeff Layton <jlayton@redhat.com>
>>
>
>
>
> --
> Thanks,
>
> Steve
>



-- 
Thanks,

Steve
