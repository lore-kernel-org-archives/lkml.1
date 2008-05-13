Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYEMJYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYEMJYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYEMJYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:24:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYEMJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:24:37 -0400
Subject: Re: System call audit
From: David Woodhouse <dwmw2@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080513000617.GA26009@Krystal>
References: <20080513000617.GA26009@Krystal>
Content-Type: text/plain
Date: Tue, 13 May 2008 10:24:29 +0100
Message-Id: <1210670669.3582.219.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-12 at 20:06 -0400, Mathieu Desnoyers wrote:
> Hi David,
> 
> As I am looking into the system-wide system call tracing problem, I
> start to wonder how auditsc deals with the fact that user-space could
> concurrently change the content referred to by the __user pointers.

In general we have to copy the content into kernel space, audit it, and
then act on it from there. See the explanation on the IPC audit patch at
http://lwn.net/Articles/125350/ for example.

Auditing one thing and then acting on another would be simply broken.

> This would be the case for execve. If we create a program with two
> thread; one is executing execve syscalls and the other thread would be
> modifying the userspace string containing the name of the program to
> execute.

I was going to suggest that that attack vector won't work, because
execve() kills all threads. But all you have to do to avoid that is put
the data in question into a shared writable mmap and modify it from
another _process_. And in fact I suspect there's a combination of CLONE_
flags which would avoid the thread-killing behaviour anyway.

>  Since we have two copy_from_user, one in auditsc and one in the
> real execve() function, the string passed to the OS could differ from
> the string seen by auditsc.

Right. Don't Do That Then. The audit code should see what's _actually_
given to the child process. The audit/execve code has changed since I
last looked, but I think it's probably OK because it's reading the
contents of the new program's mm on the way back from the execve()
system call -- before ever giving the CPU back to that process.

-- 
dwmw2

