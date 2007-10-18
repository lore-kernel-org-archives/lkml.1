Return-Path: <linux-kernel-owner+w=401wt.eu-S1765204AbXJRU3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765204AbXJRU3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764258AbXJRU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:26:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59513 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764721AbXJRU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:26:35 -0400
Date: Thu, 18 Oct 2007 21:26:27 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 8 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071018202627.GP8181@ftp.linux.org.uk>
References: <20071018045705.GM8181@ftp.linux.org.uk> <986439.75573.qm@web36607.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <986439.75573.qm@web36607.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 01:13:02PM -0700, Casey Schaufler wrote:

> CPU1 sets smk_next to smack_known. 
> CPU1 fills in the rest of the entry.
> CPU1 sets smack_known to skp (the entry).
> 
> CPU2 will either see the old value for smack_known,
> in which case this entry isn't actually on the list yet,
> or it will see the new value in smack_known. Since smk_next
> is set before the entry is added to the list, it seems that
> the scenario you've outlined shouldn't happen.

Why?  Writes from CPU1 don't have to be seen in the same order on CPU2.
Compiler has every right to turn that into
	load from smack_known
	store to ->smk_next
	...
	store to smack_known
and there's no reason whatsoever why these two stores won't be seen
out of order on CPU2 - there's no barrier and all we have is a bunch
of assignments from registers to various (nonrepeating) addresses in
memory.  On out-of-order architectures they can be reordered just fine
by CPU itself...

You need at least a barrier, assuming that you want to keep that kind
of lockless access in readers (actually, I wonder if that list is a
good choice of data structure here - you are using it as a symbol table
and depending on the expected use pattern there might be better choices
for that).
