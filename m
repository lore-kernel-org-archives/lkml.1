Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbYAWKyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbYAWKyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYAWKxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:53:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752041AbYAWKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:53:53 -0500
Date: Wed, 23 Jan 2008 10:51:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove BKL from sysctl(2)
Message-ID: <20080123105140.3406e25b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080122202727.GB1975@martell.zuzino.mipt.ru>
References: <20080122202727.GB1975@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008 23:27:27 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> /proc/sys part of sysctl code runs without BKL held, so BKL during
> sysctl(2) is useless. Remove misleading comment and "protection" around
> coredumping code -- kernel.core_pattern can be written without BKL.
> 
> do_sysctl() and lookup in /proc/sys use identical iterators, so any locking
> bug BKL supposedly fixed in sysctl(2) code we should have in /proc/sys
> code anyway.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

NAK

The core dump locking is now totally unprotected rather than slightly
dubious. This patch needs to go in together with a parallel patch to
actually lock properly. You've made a bug worse not fixed it.

There are cases that updating the corepath name and dumping a core at the
same moment can result in the wrong thing being exec()'d or a file being
opened which is a mix of the old and new name and could go anywhere.

I see two variants on your patch that work

#1	Replace the lock_kernel with a sysctl_update mutex and fix both
paths
#2	Add locking specifically to the corename path



Alan
