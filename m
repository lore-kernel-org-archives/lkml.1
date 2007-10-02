Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbXJBS15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbXJBS15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXJBS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:27:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbXJBS1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:27:49 -0400
Message-ID: <47028D99.8020100@redhat.com>
Date: Tue, 02 Oct 2007 14:27:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Kirill Korotaev <dev@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] mark read_crX() asm code as volatile
References: <470250E0.5090706@openvz.org> <20071002082856.3c478e66@laptopd505.fenrus.org>
In-Reply-To: <20071002082856.3c478e66@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2007 11:28 AM, Arjan van de Ven wrote:
> On Tue, 02 Oct 2007 18:08:32 +0400
> Kirill Korotaev <dev@openvz.org> wrote:
> 
>> Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from
>> gentoo) can generate incorrect code with read_crX()/write_crX()
>> functions mix up, due to cached results of read_crX().
>>
> 
> I'm not so sure volatile is the right answer, as compared to giving the
> asm more strict contraints....
> 
> asm volatile tends to mean something else than "the result has
> changed"....

It means "don't eliminate this code if it's reachable" which should be
just enough for this case. But it could still be reordered in some cases
that could break, I think.

This should work because the result gets used before reading again:

read_cr3(a);
write_cr3(a | 1);
read_cr3(a);

But this might be reordered so that b gets read before the write:

read_cr3(a);
write_cr3(a | 1);
read_cr3(b);

?
