Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbXCUXyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbXCUXyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934083AbXCUXyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:54:09 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:53546 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932334AbXCUXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:54:07 -0400
Date: Thu, 22 Mar 2007 00:53:10 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim <maximlevitsky@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       David Howells <dhowells@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] : Is /proc/kcore still usefull and/or maintained ?
Message-Id: <20070322005310.03be8637.dada1@cosmosbay.com>
In-Reply-To: <200703220128.18610.maximlevitsky@gmail.com>
References: <200703211840.53242.maximlevitsky@gmail.com>
	<4601B89E.3060605@cosmosbay.com>
	<Pine.LNX.4.61.0703220011080.9555@yvahk01.tjqt.qr>
	<200703220128.18610.maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 22 Mar 2007 00:53:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I stand corrected : This is a new bug

The /proc/kcore problem appears with linux-2.6.21-rc4-mm1

fd = open("/proc/kcore", 0);
llseek(fd, ...) returns an -EINVAL error


Quick code inspection (before going to sleep...) shows that

proc_reg_llseek() (file fs/proc/inode.c)

is doing something like :

rv = -EINVAL;
llseek = pde->proc_fops->llseek;
spin_unlock(&pde->pde_unload_lock);
if (llseek)
	rv = llseek(file, offset, whence);

As kcore dont have a .llseek handler, proc_reg_llseek() returns -EINVAL;

Previous kernel was probably calling a default llseek() handler.

if (!llseek)
	llseek = default_llseek;

Hum ???
