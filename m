Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZJ2CUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZJ2CUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZJ2CUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:20:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47049 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbZJ2CUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:20:19 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz>
	<20091026163157.GB7233@duck.suse.cz>
	<20091026165729.GF23564@us.ibm.com>
	<20091026173629.GB16861@fieldses.org>
	<20091026174631.GD7233@duck.suse.cz>
	<1256579869.8576.7.camel@heimdal.trondhjem.org>
	<20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org>
	<20091028081653.GA18290@elf.ucw.cz> <m1k4yfkbfg.fsf@fess.ebiederm.org>
	<20091028210323.GA4159@elf.ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 28 Oct 2009 19:20:12 -0700
In-Reply-To: <20091028210323.GA4159@elf.ucw.cz> (Pavel Machek's message of "Wed\, 28 Oct 2009 22\:03\:24 +0100")
Message-ID: <m1hbtj7xgj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> >> > Well, it is unexpected and mild security hole.
>> >> 
>> >> /proc/<pid>/fd is only viewable by the owner of the process or by
>> >> someone with CAP_DAC_OVERRIDE.  So there appears to be no security
>> >> hole exploitable by people who don't have the file open.
>> >
>> > Please see bugtraq discussion at
>> > http://seclists.org/bugtraq/2009/Oct/179 .
>> >
>> > (In short, you get read-only fd, and you can upgrade it to read-write
>> > fd. Yes, you are the owner of the process, but you are not owner of
>> > the file the fd refers to.)
>> 
>> Assuming you have permission to open it read-write.
>
> Please see the bugtraq discussion.
>
> It works even if you would not have permission to write to it with
> /proc unmounted.
>
>> >> Openly if you actually have permission to open the file again.  The actual
>> >> permissions on the file should not be ignored.
>> >
>> > The actual permissions of the file are not ignored, but permissions of
>> > the containing directory _are_. If there's 666 file in 700 directory,
>> > you can reopen it read-write, in violation of directory's 700
>> > permissions.
>> 
>> I can see how all of this can come as a surprise.  However I don't see
>> how any coder who is taking security seriously and being paranoid about
>> security would actually write code that would have a problem with
>> this.
>
> So, there's "surprise" that gives _you_ write access to my files. You
> agree that it is surprising, and you would not have write access to my
> file if /proc was not mounted.

I also find it a surprise you would ever make a file world writable.

I find it a surprise that in any application that cared you would allow the
file to be opened, or passed through a unix domain socket and then have
the permissions changed.

> Call it "security surprise" if you prefer. But many people call it
> "security hole".
>
>> Do you know of any cases where this difference matters in practice?
>
> No. Do you have a proof that it does not matter anywhere?
>
>> It looks to me like it has been this way for better than a decade
>> without problems so there is no point in changing it now.  
>
> Unix compatibility?

Thinking about this proc fundamentally gives you the ability to create
(via open) a new file descriptor for a file you already have open.

That is the design and things are working by design.

I do see a security issue in your example, but the security issue I
see is how you have chosen to use the linux facilities, that have been
there for ages.  Facilities cloned from plan 9 and apparently
available in slightly different forms on many unix variants existence.
/dev/fd/N is not a linuxism.

To close this whole would require some sort of stacking inode that
when opened opened the real fs inode.  With all kinds of convolutions
and complications.  Just to close the issue that some idiot might
give someone a fd to a world writeable file that they don't want
them to open.

Given this is an old well established facility with a long tradition,
that does not appear to be easy or simple to exploit.  I believe the burden
of proof has not been met to say the design has a security issue.

I certainly am not interested in debugging or maintaining the stacking
inode code that would be necessary to close this theoretical corner
case.  There are much more real bugs that need attention.

Eric
