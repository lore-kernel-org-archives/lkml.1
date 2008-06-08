Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbYFHLji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbYFHLji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYFHLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:39:30 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:57869 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYFHLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:39:29 -0400
Message-ID: <484BC4DF.5000605@thorsten-knabe.de>
Date: Sun, 08 Jun 2008 13:39:11 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org> <20080602010546.GA8578@c2.user-mode-linux.org> <484719C7.2020502@thorsten-knabe.de> <20080605004925.GA15461@c2.user-mode-linux.org>
In-Reply-To: <20080605004925.GA15461@c2.user-mode-linux.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Report: SpamAssassin@thorsten-knabe.de:
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> I misunderstood - I thought you were seeing a task_struct leak within
> UML rather than a leak on the host elicited by UML.
> 
>> As far as I understand the UML code in the kernel, an UML kernel uses
>> some unusual clone() flags when creating new processes, which are seldom
>> used by other applications and could be related to the bug.
> 
> Yes, it does.  I don't see the flags causing a leak, though.  What
> might be more likely (although I really have no idea) is ptrace.
> Possibly a reference is held when it should have been dropped.  This
> might also show up with strace or gdb.

Hello Jeff.

Your assumption about ptrace causing the task_struct leak seems to be
right. I bisected the problem down to a few commits using the repository
at git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git.

Commit b7b71725fb9584454bfe5f231223bd63421798fb is the last known commit
that does not leak task_structs, whereas commit
a97f52e67890fda6b373c1c1895ff1c1c69b36c8 is leaking task_structs.
Revisions in between do not even compile.
Also I had to apply the changes from commit
f9cb02b0be4de3c51edfdd701754e13d9a2d20d6 to most of the kernels I have
tested, otherwise the UML process would crash on startup.

HTH
Thorsten

-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
