Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZFXXtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZFXXtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZFXXtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:49:12 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37059 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZFXXtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fh5rUBo6Xs9mNIQkdavgVzzBsr3NajnxE+NgKl8UlPkxBkOJxQ6PjW3jQPVX5YDd6z
         xISHw0Sm1WhhcG/dzylfPszWkzwKhprdqxLwFxST8f4E9EerXDW0XhwER0VdepqQ9Yl9
         Zdzj8Hix7Sb7R1DcTfSrDrSmLwcBQ5lfMTU5k=
MIME-Version: 1.0
In-Reply-To: <20090624162125.a3a9b2c4.akpm@linux-foundation.org>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
	 <20090624162125.a3a9b2c4.akpm@linux-foundation.org>
Date: Thu, 25 Jun 2009 01:49:13 +0200
Message-ID: <1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, vapier@gentoo.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 1:21 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Thu, 25 Jun 2009 01:00:56 +0200
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
>> In some circumstances running process needs to re-execute
>> its image.
...
>> More elegant way is to execute /proc/self/exe.
>> This works just fine as long as /proc is mounted.
>>
>> But it breaks if /proc isn't mounted, and this can happen in real-world
>> usage. For example, when shell invoked very early in initrd/initramfs.
>
> Why can't userspace mount /proc before doing the daemonization?

Some people want to unset CONFIG_PROC_FS, and still have
working POSIX compatible shell. Coincidentally, NOMMU
machines, ones which *require* re-execution of the shell to support that,
tent to be the most memory starved machines too (thus most likely
to be those where people desire to unset CONFIG_PROC_FS).

> Oh geeze.  Hard-coded "/proc/self/exec" it the middle of the core exec
> code?  You're a brave man.

There are other alternatives. This looked to be the least ugly
to me.

We can special-case execve(NULL, ...).
But I feared people would say this will change previously-buggy
userspace code into one acting weirdly; in come cases
leading to infinite execve loops. Do you think it's better
than "/proc/self/exe"?

Then I thought about using a special name to mean "re-execute me",
like "", or "/./self" or whatever. Whatever I though about,
it was either risking a collision with a real file, or was too ugly,
or both.

Then it occurred to me that "/proc/self/exe" _already is_
such a name. It is _already used_ for this purpose, so the userspace
does not need to be changed.

For the extra non-intrusiveness, the hack kicks in only if
/proc/self/exe does not exist.


[code style notes skipped. I will re-write it in whatever form
 you like it most, when/if it will be agreed on in principle ]

> But don't do any of that yet.  This will be an unpopular patch and I
> fear for its future ;)

Propose some other way to make it possible to re-execute a binary
without /proc.
--
vda
