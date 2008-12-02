Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbYLBUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbYLBUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYLBUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:20:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18231 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYLBUUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UkCW3CUOd+jAdQE8uxipQ9jNLHIGIntXBQQqAApRRSvfJn39QMJV7C3m0E97y96Bnc
         pKg6Ivc2Jn88VgtFiRH8IA/zzZneQayQD7fAj0LqF5MLys1ElmnH44JBv7gY7QpaLqki
         im/CKGXH2IBf4Bk3XnpLzCA4xyBkTG+BwlOtg=
Message-ID: <524f69650812021220n2b7611b9x2eb3b0b6c7ece849@mail.gmail.com>
Date: Tue, 2 Dec 2008 14:20:29 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: Support for applications which need NFS or CIFS "share_deny" flags on open
Cc: "Andreas Dilger" <adilger@sun.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
In-Reply-To: <20081202200621.GA4451@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com>
	 <20081202193819.GJ3186@webber.adilger.int>
	 <20081202200621.GA4451@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 2:06 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Andreas Dilger wrote:
>> This is a disaster waiting to happen, and I would be against adding
>> such functionality to Linux.  It would allow userspace applications
>> to implement a denial of service to any file that they can open (e.g.
>> open("/lib/libc-2.7.so", O_DENYREAD) would be really bad :-).
>>
>> It was always also a pain in the ass on Windows systems (back when I used
>> them) that backing up the filesystem would fail because something (app or
>> kernel) had files open in this mode and the backup tool couldn't even read
>> them to do the backup.  In some cases these files were opened very early
>> in boot and the only way to do a full backup was to boot from a separate
>> device and run the backup.  Not my idea of fun.
>
> It's a pain on Windows, yes.  It's necessary because you can't delete
> or rename over an open file (the unix way), so for files which must be
> updated without any program seeing them as temporarily corrup (.exe,
> .dll, config files, pid files, etc.) to do it on Windows is
> open-with-deny-read and write the new file contents.
>
>> I can't see any reason for O_DENYREAD or O_DENYWRITE that can't be met
>> with existing file locking to maintain coherency if that is really needed.

I don't see how O_DENYREAD or more importantly, O_DENYWRITE can help.
If client A (Linux/Wine) does an open O_DENYWRITE, and we don't send
the O_DENYWRITE on open, Samba (or Windows or NetApp or random NAS
appliance etc.)
will allow the open even if another Windows client is writing to the
file.   The Linux/Wine
subsystem could try to do a posix byte range lock from byte 0 to end
of file and that
would get mapped by the cifs client to a mandatory lock, but it
doesn't help the case
where another Windows client already has the file open for write, and you expect
the open from your client to fail in that case.

> Is there any reason why Wine cannot take an advisory lock _every_ time
> it opens a file?  That would give Windows apps the behaviour they
> expect, including across the network, without DOSing unix apps.
>
>> As for O_DENYDELETE - wouldn't that be irrelevant if the WINE code keeps
>> an open file reference?  The data would still be accessible until WINE
>> exits, and it wouldn't be a DOS.
>
> Windows apps do expect a file can't disappear while it's open.  This
> is one way to detect if an app is running, and this particular
> behaviour goes back to the oldest versions of Windows.
>
> Inside a single WINE instance or on a single host, your suggestion
> works, but what about Windows apps on different hosts over a network share?
>
> The bit I find interesting is that other CIFS clients are said to
> implement these flags.  If that means real unixes, maybe they've
> worked out a sensible way to handle them?

I thought that MacOS uses these flags (not just Windows, and of course
older clients too OS/2, DOS etc.).


-- 
Thanks,

Steve
