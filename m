Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZFZXSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZFZXSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZFZXS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:18:26 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:50493 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbZFZXSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FNpQ1351+INXf25m/Oxwr+bWeEg0r9APGBU4/M/jq3846sQNbc+4BD7COWGWjBN9Yh
         QuesYkYJbkDizstFVoWssAuLDcuNlZJ3fN+c6exl7UTO6mPllKxiNAm3dnc5TZIDUccc
         EciNU1Pu+JRyoAVMPip6XVuPCAq4nsDO2uIqU=
MIME-Version: 1.0
In-Reply-To: <20090624235856.GZ8633@ZenIV.linux.org.uk>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
	 <20090624235856.GZ8633@ZenIV.linux.org.uk>
Date: Sat, 27 Jun 2009 01:18:27 +0200
Message-ID: <1158166a0906261618g48605091y2478b832fb25b9a3@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 1:58 AM, Al Viro<viro@zeniv.linux.org.uk> wrote:
>> With this patch, it is possible to execute /proc/self/exe
>> even if /proc is not mounted.
>
>> How patch does it: when execve syscall discovers that opening of binary
>> image fails, a small bit of code is added to special case "/proc/self/exe"
>> string. If binary name is *exactly* that string, and if error is ENOENT
>> or EACCES, then exec will still succeed, using current binary's image.
>>
>> Please apply.
>
> No.  This is just plain sick.  Magical pathnames have no business being
> in the kernel.

This is not a magical *pathname*. It only looks like it.
This is the magic 1st argument of execve which makes it perform reexecve().
Sorry, I had to explain it in the first email...

Creating entire new syscall reexecve() just for this purpose seems excessive.
Special-casing execve allows to avoid this.

I could have used "Please reexec me!!!" as a magic 1st parameter to execve.
This has two downsides: the string, however weird, still *can* match
a real file. Second, userspace needs to be modified to use such a name.

Magic parameter of the form "/proc/self/exe" does not suffer from
2nd problem. Userspace already uses it exactly for this purpose,
no change needed.

> If procfs is too much for your sensitive soul, do an
> extremely trimmed-down version that would consist of *one* *file* (yes,
> as root and only node on fs).  Said file being a procfs-style symlink,
> doing exactly what /proc/self/exec would do.
>
> On such system you can just mkdir /proc/self, touch /proc/self/exec,
> mount -t self_exec none /proc/self/exec and be done with that.  No
> magic needed, end of the story.

This would use many times more memory than a small code addition
on an execve's error path I posted.

It also would require mounting a filesystem. So the shell started by
init=/bin/sh on NOMMU machine either will need to be programmed
to do it when execve("/proc/self/exe") fails, or the user will need
to be taught to do it by hand before user can be sure the shell
will be able to run some POSIX constructs like function calls
in pipes etc.

--
vda
