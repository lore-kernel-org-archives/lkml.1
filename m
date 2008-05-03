Return-Path: <linux-kernel-owner+w=401wt.eu-S936440AbYECAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936440AbYECAao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbYECAae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:30:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbYECAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:30:33 -0400
Date: Fri, 2 May 2008 17:30:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
Message-Id: <20080502173030.33c40213.akpm@linux-foundation.org>
In-Reply-To: <1209773755.26173.114.camel@brick>
References: <1209754916.26173.39.camel@brick>
	<20080502.162515.14823435.davem@davemloft.net>
	<20080502163131.a13c0774.akpm@linux-foundation.org>
	<1209772363.26173.101.camel@brick>
	<20080502170802.456493a5.akpm@linux-foundation.org>
	<1209773755.26173.114.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 17:15:55 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> int hex_char_to_int(char ch)
> {
> 	return -1 if not [a-fA-F0-9]
> }
> 
> int hex_to_u8(const char *buf, u8 *val)
> int hex_to_u16(const char *buf, u16 *val)
> int hex_to_u32(const char *buf, u32 *val)
> int hex_to_u64(const char *buf, u64 *val)
> 
> Which return the number of chars read and reads up to a maximum of
> 2,4,8,16 chars respectively and returns early if a non-hex char
> is encountered.
> 
> Thoughts?

I dunno.  Return-by-reference is a bit nasty and forces the compiler to
generate extra code to put local storage into a stack slot rather than
keeping it in a register.


Does anyone actually test whether hex_to_foo returns -1?  Probably not
many.

In which case it might be better to do

u64 hex_to_u64(const char *buf);

and, if we encounter a non-hex char, do a WARN_ON(1).


One could legitimately do

	int c = hex_to_int(some_user_input);
	if (c < 0) {
		printk("user: you're an idiot\n");
	}

to perform validation and conversion in a single operation but I expect
that such code is in the minority, and could be covered by running a separate

bool is_hex_string(const char *bug, size_t nchars);

beforehand?
