Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYGJOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYGJOPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYGJOPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:15:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026AbYGJOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:15:12 -0400
Message-ID: <4876194E.4080205@linux-foundation.org>
Date: Thu, 10 Jul 2008 09:14:38 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org>
In-Reply-To: <487556A5.5090907@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the zero based approach you do not have a relative address anymore. We are basically creating a new absolute address space where we place variables starting at zero.

This means that we are fully independent from the placement of the percpu segment.

The loader may place the per cpu segment with the initialized variables anywhere. We just need to set GS correctly for the boot cpu. We always need to refer to the per cpu variables
via GS or by adding the per cpu offset to the __per_cpu_offset[] (which is now badly named because it points directly to the start of the percpu segment for each processor).

So there is no 2G limitation on the distance between the code and the percpu segment anymore. The 2G limitation still exists for the *size* of the per cpu segment. If we go beyond 2G in defined per cpu variables then the per cpu addresses will wrap.
