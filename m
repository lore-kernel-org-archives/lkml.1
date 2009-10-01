Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZJARza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZJARza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZJARza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:55:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZJARz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:55:29 -0400
References: <20091001145547.GA29152@shell> <7004b08e0910010838i6d0a5f5xeed699be686f6906@mail.gmail.com> <20091001171547.GE29152@shell>
Message-Id: <56A500B5-DEC5-4B4E-A224-6F5F2D702D2B@suse.de>
From: Jan Blunck <jblunck@suse.de>
To: Valerie Aurora <vaurora@redhat.com>
In-Reply-To: <20091001171547.GE29152@shell>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: [RFC] Union mounts/writable overlays design
Date: Thu, 1 Oct 2009 19:55:14 +0200
Cc: kevin granade <kevin.granade@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.10.2009 um 19:15 schrieb Valerie Aurora <vaurora@redhat.com>:

> On Thu, Oct 01, 2009 at 10:38:27AM -0500, kevin granade wrote:
>> Wow, amazingly thorough writeup, was a very interesting read and  
>> I'm looking
>> forward to trying this out.
>>
>> Examples
>>> ========
>>>
>>> What happens when I...
>>>
>>> - creat() /newfile -> creates on top layer
>>> - unlink() /oldfile -> creates a whiteout on top layer
>>> - Edit /existingfile -> copies up to top layer at open(O_WR) time
>>> - truncate /existingfile -> copies up to top layer + N bytes if  
>>> specified
>>> - touch()/chmod()/chown()/etc. -> copies up to top layer
>>> - mkdir() /newdir -> creates on top layer
>>> - rmdir() /olddir -> creates a whiteout on top layer
>>> - mkdir() /olddir after above -> creates on top layer w/ opaque flag
>>> - readdir() /shareddir -> copies up entries from bottom layer as  
>>> fallthrus
>>> - link() /oldfile /newlink -> copies up /oldfile, creates /newlink  
>>> on top
>>> layer
>>> - symlink() /oldfile /symlink -> nothing special
>>> - rename() /oldfile /newfile -> copies up /oldfile to /newfile on  
>>> top layer
>>>
>>
>> Minor quibble here, rename should also whiteout /oldfile, of course  
>> you have
>> it explained correctly in the detailed description of rename() below.
>> Or am I misunderstanding and the above is what it does now and the  
>> detailed
>> description is what it will do once implemented properly?
>
> Hi Kevin,
>
> You are correct, it whiteouts the original name.  Thanks for pointing
> that out!
>
>>> Non-features
>>> ------------
>>>
>>> Features we do not currently plan to support as part of writable
>>> overlays:
>>>
>>> Online upgrade: E.g., installing software on a file system NFS
>>> exported to clients while the clients are still up and running.
>>> Allowing the read-only bottom layer to change while the writable
>>> overlay file system is mounted invalidates our locking strategy.
>>>
>>
>> So as long as the RO filesystem is NOT mounted as part of an  
>> overlay, you
>> could modify it and then re-construct the previous overlay and  
>> things will
>> work as expected?
>> For example could one create a hard drive over CD overlay, then  
>> periodically
>> (requiring a reboot probably) replace the underlying CD with a new  
>> version
>> and automagically have new versions of software available?   
>> ( obviously
>> there are additional complexities in packaging to make this work,  
>> but having
>> support in the kernel is the first step. )
>
> This could theoretically work, but the main problem is resolving
> differences between files (always the big problem in upgrade).  Say
> you have /etc/passwd, you add a new user and write to it on the top
> layer, and then the next upgrade adds a new user to the read-only
> version.  You're not going to see the new user.
>

No. Scripts that come with updated packages still need to run on the  
union. Otherwise this is just asking for problems. Probably you could  
come up with a clever merger if the update and the base image is still  
available.

>> One last thing, I don't see this in either the "features" or the
>> "non-features".  Will there be a way to "revert" a file to the RO  
>> version
>> once it has been copied up, either by just removing the overlay  
>> entry or by
>> somehow forcing the open of the underlying file when it has an  
>> overlay?  Now
>> that I think of it, one could just mount the underlying filesystem  
>> elsewhere
>> and copy the file, but I'd still be interested to know if there is  
>> any
>> desire to provide the more "direct" operation.
>
> I think that people are calling this "punch-through."  I don't see a
> problem with it, other than slightly more kernel support.
>
> -VAL
