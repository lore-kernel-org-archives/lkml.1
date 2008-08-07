Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYHGOVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYHGOVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYHGOVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:21:13 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:35313 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYHGOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AzK9XM5J4CzB0arfdLsFUUfKnCNZ3g9uziINkeXktAGPfMrt2RpIV/QSFBekSvAMF8
         IxNFvewsfg61JDK0VM8R2vyFlp+fqGmeLgYH4wJk/2+WVfR7Rqt1SMBz1/mdDmI1SzuF
         l3lAMoZ8KSelWN+k2agxczGvIaXKQ/TsG6euQ=
Message-ID: <e7d8f83e0808070721l2dd38f0dyd0366520e9131b1a@mail.gmail.com>
Date: Fri, 8 Aug 2008 00:21:10 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Cc: tvrtko.ursulin@sophos.com, "Arjan van de Ven" <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <20080807092800.GA22222@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806064418.6afa0672@infradead.org>
	 <20080806141656.8B44B2FE94A@pmx1.sophos.com>
	 <20080807092800.GA22222@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 7:28 PM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> Problems with inotify as far as I know:
>>
>> You can't do something like inotify("/") (made up API) but you have to set
>> up a watch for every directory you wan't to watch. That seems like a waste
>> of resources.
>>
>> Then you get back a file name, if you wan't to report it or attempt* to
>> scan it you have to build a pathname yourself, which means you have to
>> maintain the whole tree of names in memory. Even bigger waste.
>>
>> When I say attempt to scan it above I mean that we are back into the
>> pathanme teritorry. It is not guaranteed we will be able to open and scan
>> using that pathname. I don't know what inotify reports with chroots and
>> private namespaces, but it can certainly fail with NFS and root_squash. So
>> it is less effective as well as being resource intensive.
>>
>> I think this is a good amount of flaws which shows inotify isn't really
>> ideal.
>
> Not ideal, but looks like good enough, and could certainly be
> improved. If it is secure-enough for you (I think it is), that looks
> like a way to go.
>
> (Plus, such improvements would actually be very welcome).
>                                                                        Pavel
>
My Issue API does not have to be made up.  The API kinda exists in
Credentials for a completely different use.

Issue with inotify its only monitoring.   No permission alteration to
block access.

Also its the wrong level.   I will explain why.

inotify is sitting on top of the vfs.   Ok fine if you don't want scan
effectiveness.   With bind mounts this becomes trouble quickly.

/tmp
/usr/tmp
/usr/local/tmp

All could be exactly the same physical drive.   Now in the anti-virus
would have to scan each of thoose directories if it does not find out
they are bind mounted.  Also could not look up and say ok that is bind
mounted its fine because since the last lookup a new bind mount could
have been put over the top letting something slip past.

Also TALPA is wrong because its a LSM.   LSM are the most powerful
bits of the OS.   LSM are the enforcers of Linux.  They are the last
line of defence for the OS.   You have your normal permission systems
when they fail then its the job of a LSM to pick up the mess.

Virus scanning is way better inside the permission system.   This way
if you have a issue there is still a back stop of the LSM to prevent a
breached virus scanner doing major system harm.   TALPA risks killing
the backstop.

Basically path based + Linux equals doomed.  VFS is not path based friendly.

Credentials patch on the other hand.  Is under the VFS sees real
partitions so can process divided by partition avoiding rescanning.
Also its in the permission system to has to get approve from the LSM
to do alterations.  So its back stoped.

Also is sitting at exactly the right point to override permissions.

Filesystem cache that exists to sit on top of Credentials provides the
other needed bit scan on write function.

Also filesystem driver level was also correct.  Same reason not messed
up by VFS multi mounting and over mounting.

Don't worry lots of things have been made as LSM's that should not
been.  Basically avoiding having to correct the right things.

Peter Dolding
