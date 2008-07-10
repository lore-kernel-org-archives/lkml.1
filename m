Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbYGJPtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbYGJPtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYGJPtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:49:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYGJPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:49:16 -0400
Message-ID: <48762DD2.5090802@zytor.com>
Date: Thu, 10 Jul 2008 11:42:10 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>
In-Reply-To: <48762A3B.5050104@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> 
> Well the zero based results in this becoming always
> 
> 	gs_base + absolute address in per cpu segment

You can do either way.  For RIP-based, you have to worry about the 
possible range for the RIP register when referencing.  Currently, even 
for "make allyesconfig" the per cpu segment is a lot smaller than the 
minimum value for CONFIG_PHYSICAL_START (2 MB), so there is no issue, 
but there is a distinct lack of wiggle room, which can be resolved 
either by using negative offsets, or by moving the kernel text area up a 
bit from -2 GB.

> Why are RIP based references cheaper? The offset to the per cpu segment is certainly more than what can be fit into 16 bits.

Where are you getting 16 bits from?!?!  *There are no 16-bit offsets in 
64-bit mode, period, full stop.*

RIP-based references are cheaper because the x86-64 architects chose to 
optimize RIP-based references over absolute references.  Therefore 
RIP-based references are encodable with only a MODR/M byte, whereas 
absolute references require a SIB byte as well -- longer instruction, 
possibly a less optimized path through the CPU, and *definitely* 
something that gets exercised less in the linker.

	-hpa
