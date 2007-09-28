Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbXI1Bif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbXI1Bif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbXI1Bi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:38:27 -0400
Received: from science.horizon.com ([192.35.100.1]:18155 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754842AbXI1Bi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:38:26 -0400
Date: 27 Sep 2007 21:38:22 -0400
Message-ID: <20070928013822.28348.qmail@science.horizon.com>
From: linux@horizon.com
To: vegard.nossum@gmail.com
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Example: {
>	struct kprint_block out;
>	kprint_block_init(&out, KPRINT_DEBUG);
>	kprint_block(&out, "Stack trace:");
>
>	while(unwind_stack()) {
>		kprint_block(&out, "%p %s", address, symbol);
>	}
>	kprint_block_flush(&out);
> }

Assuming that kprint_block_flush() is a combination of
kprint_block_printit() and kprint_block_abort(), you
coulld make a macro wrapper for this to preclude leaks:

#define KPRINT_BLOCK(block, level, code) \
do { \
	struct kprint_block block; \
	kprint_block_init(&block, KPRINT_##level); \
	do { \
		code ; \
		kprint_block_printit(&block); \
	while (0); \
	kprint_block_abort(&block); \
} while(0)

The inner do { } while(0) region is so you can abort with "break".

(Or you can split it into KPRINT_BEGIN() and KPRINT_END() macros,
if that works out to be cleaner.)
