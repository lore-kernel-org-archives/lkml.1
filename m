Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXJCEqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXJCEqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJCEqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:46:30 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:41596 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751217AbXJCEq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:46:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nD5LoXWW6voyO9bzpkicaBZRZQ2dLwxaLUUxEwPl7HdPVSXcNdQhAMLKiXDoMkIQ1K5s6yYmADflJ9lIT62aNE3Zcj3bVgGT09fCSewGRTc+0WgZUycC8xwQcPqGqXw6oBDoXDI46fjWAaOhEwsgT1zqnSFRkRuY+MeA32kb8Z4=  ;
X-YMail-OSG: xHqVaRsVM1kJtWMWjLxjXx2QFP2i3rSRsxrPO.WIzHSi8S7v
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] mark read_crX() asm code as volatile
Date: Tue, 2 Oct 2007 22:14:54 +1000
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Kirill Korotaev <dev@openvz.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
References: <470250E0.5090706@openvz.org> <20071002082856.3c478e66@laptopd505.fenrus.org> <47028D99.8020100@redhat.com>
In-Reply-To: <47028D99.8020100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022214.55381.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 04:27, Chuck Ebbert wrote:
> On 10/02/2007 11:28 AM, Arjan van de Ven wrote:
> > On Tue, 02 Oct 2007 18:08:32 +0400
> >
> > Kirill Korotaev <dev@openvz.org> wrote:
> >> Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from
> >> gentoo) can generate incorrect code with read_crX()/write_crX()
> >> functions mix up, due to cached results of read_crX().
> >
> > I'm not so sure volatile is the right answer, as compared to giving the
> > asm more strict contraints....
> >
> > asm volatile tends to mean something else than "the result has
> > changed"....
>
> It means "don't eliminate this code if it's reachable" which should be
> just enough for this case. But it could still be reordered in some cases
> that could break, I think.
>
> This should work because the result gets used before reading again:
>
> read_cr3(a);
> write_cr3(a | 1);
> read_cr3(a);
>
> But this might be reordered so that b gets read before the write:
>
> read_cr3(a);
> write_cr3(a | 1);
> read_cr3(b);
>
> ?

I don't see how, as write_cr3 clobbers memory.
