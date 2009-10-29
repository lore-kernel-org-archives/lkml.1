Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZJ2QXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZJ2QXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbZJ2QXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:23:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53390 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbZJ2QXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:23:52 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
References: <20091026165729.GF23564@us.ibm.com>
	<20091026173629.GB16861@fieldses.org>
	<20091026174631.GD7233@duck.suse.cz>
	<1256579869.8576.7.camel@heimdal.trondhjem.org>
	<20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org>
	<20091028081653.GA18290@elf.ucw.cz> <m1k4yfkbfg.fsf@fess.ebiederm.org>
	<20091028210323.GA4159@elf.ucw.cz> <m1hbtj7xgj.fsf@fess.ebiederm.org>
	<20091029110344.GA1517@ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 29 Oct 2009 09:23:46 -0700
In-Reply-To: <20091029110344.GA1517@ucw.cz> (Pavel Machek's message of "Thu\, 29 Oct 2009 12\:03\:44 +0100")
Message-ID: <m1d4466uel.fsf@fess.ebiederm.org>
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
>> >> It looks to me like it has been this way for better than a decade
>> >> without problems so there is no point in changing it now.  
>> >
>> > Unix compatibility?
>> 
>> Thinking about this proc fundamentally gives you the ability to create
>> (via open) a new file descriptor for a file you already have open.
>
> Yes. Problem is that by using /proc, I can work-around open(READONLY)
> restriction and work-around open(APPEND_ONLY) restriction.

If you are allowed to do that simply opening the inode.

I can also use a bind mount on the file before you lock down
permissions instead of proc in your example to achieve the same
affect.  An extra path to an inode.

In general there is not a way to lock down the path to a file to a
more restrictive set of permissions after it has been opened.  Not
until sys_revoke or similar syscall has been implemented.  Even then I
am a bit dubious.

>> I do see a security issue in your example, but the security issue I
>> see is how you have chosen to use the linux facilities, that have been
>> there for ages.  Facilities cloned from plan 9 and apparently
>> available in slightly different forms on many unix variants existence.
>> /dev/fd/N is not a linuxism.
>> 
>> To close this whole would require some sort of stacking inode that
>> when opened opened the real fs inode.  With all kinds of convolutions
>> and complications.  Just to close the issue that some idiot might
>> give someone a fd to a world writeable file that they don't want
>> them to open.
>
> Ok, so you agree issue is there. Good.

I don't agree that the kernel has a problem.  I agree that there
is a security hole in your example.

I don't believe you can rely on the directory permissions in the general
case to control access to a file.

> Now, fix for READONLY issue should be fairly simple: follow link in
> /proc/*/fd/* should check the link permissions,  and return
> read-only/write-only descriptors as neccessary.

The follow_link is just a follow link.  Either we add an extra path
to the fd or we don't.  Follow link doesn't know it is being used for open.

That isn't completely correct.  You might be able to look at the
intent and if it is LOOKUP_OPEN and the open mode is compatible return
the original file descriptor.  Even if you do that and the kernel is
guaranteed to take that path in all examples that still leaves an
extra path for syscalls that don't require a filedesciptor to use.

> Basically, that follow link should behave as dup(), not as open().

There are reasons why an open is an open here.  I don't remember the
details but I found the archive of that conversation once.  Maybe it was
just technical limitations of the time.

>> I certainly am not interested in debugging or maintaining the stacking
>> inode code that would be necessary to close this theoretical corner
>> case.  There are much more real bugs that need attention.
>
> But if we can get trivial 10-liner, that should be acceptable, right?

How many linux shell scripts and other applications that use /dev/fd/N
or /proc/self/fd/N will you be breaking?

Closing a theoretical security hole at the expense of breaking real
applications is a show stopper.

Feel free to play and test but I'm still not buying it.

Eric
