Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYGJPaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYGJPaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbYGJP2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:28:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759476AbYGJP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:28:13 -0400
Message-ID: <48762A3B.5050104@linux-foundation.org>
Date: Thu, 10 Jul 2008 10:26:51 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com>
In-Reply-To: <48761C06.3020003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> Noone has talked about the actual placement of the percpu segment data.

But the placement of the percpu segment data is a problem because of the way we
currently have the linker calculate offsets. I have had kernel configurations where I changed the placement of the percpu segment leading to linker failures because the percpu segment was not in 2G range of the code segment!

This is a particular problem if we have a large number of processors (like 4096) that each require a sizable segment of virtual address space up there for the per cpu allocator.

> None of this affects the absolute positioning of the data.  The final
> address are determined by:
> 
>     fs_base + rip + offset
> or
>     fs_base + offset
> 
> ... respectively.  fs_base is an arbitrary 64-bit number; rip (in the
> kernel) is in the range [-2 GB + CONFIG_PHYSICAL_START, 0), and offset
> is in the range [-2 GB, 2 GB).

Well the zero based results in this becoming always

	gs_base + absolute address in per cpu segment

Why are RIP based references cheaper? The offset to the per cpu segment is certainly more than what can be fit into 16 bits.

