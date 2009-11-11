Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZKKXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZKKXVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbZKKXVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:21:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbZKKXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:21:35 -0500
Message-ID: <4AFB46F6.9050902@zytor.com>
Date: Wed, 11 Nov 2009 15:21:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu> <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com> <20091111071832.GA3156@elte.hu> <8FED46E8A9CA574792FC7AACAC38FE7714FE830400@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FE830400@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 11:57 PM, Ma, Ling wrote:
> Hi Ingo
> 
> This program is for 64bit version, so please use 'cc -o memcpy  memcpy.c -O2 -m64'
> 

I did some measurements with this program; I added power-of-two
measurements from 1-512 bytes, plus some different alignments, and found
some very interesting results:

Nehalem:
	memcpy_new is a win for 1024+ bytes, but *also* a win for 2-32
	bytes, where the old code apparently performs appallingly bad.

	memcpy_new loses in the 64-512 byte range, so the 1024
	threshold is probably justified.

Core2:
	memcpy_new is a win for <= 512 bytes, but a lose for larger
	copies (possibly a win again for 16K+ copies, but those are
	very rare in the Linux kernel.)  Surprise...

	However, the difference is very small.

However, I had overlooked something much more fundamental about your
patch.  On Nehalem, at least *it will never get executed* (except during
very early startup), because we replace the memcpy code with a jmp to
memcpy_c on any CPU which has X86_FEATURE_REP_GOOD, which includes Nehalem.

So the patch is a no-op on Nehalem, and any other modern CPU.

Am I guessing that the perf numbers you posted originally were all from
your user space test program?

	-hpa
