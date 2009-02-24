Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZBXJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZBXJSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZBXJS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:18:28 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:44745 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754107AbZBXJS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:18:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ocDcAEE39MrDhtJYmwtubXKI3v5jVPPSoa97wsp01W+XltSJbQSbstiY/iqt8tWwxiRd0GR5+eIyTTRUrjodO53qSl12ED/dvD8Ik0p2NiRGBsakUgxzCU64JfPIIbbjLcB8q/nA8/0d5C0wnJhNoVaB99KYSSWJ0b8ySZZCDIY=  ;
X-YMail-OSG: ZViY1pMVM1nUEs62FfK7fJby5S0Nh5SfxOpJaX46nxYqhDw3lF2ok0_NWHL8hkQmUdIr12uxedRWuAGGys_gL8FZNx4bJkix5y5fbYx.aptQea0rvAwAOaLhcuuenBKT47Mw0kn6qgFBtoKgCG9d5G1JpF2IWcOKEl3zN2cQZZrnL8EBO29BoQCG1UGgZQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: sidc7 <siddhartha.chhabra@gmail.com>
Subject: Re: Copy on write and page initialization
Date: Tue, 24 Feb 2009 20:17:46 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <22175803.post@talk.nabble.com>
In-Reply-To: <22175803.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242017.46605.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 15:50:05 sidc7 wrote:
> Hi,
>
> As far as I understand, Linux uses the COW optimization so parent and child
> process share the same address space, till one of them writes to it, at

The "address space" is not shared. Ie. the logical memory space is
separate, but it happens that the actual virtual->physical mappings
can be shared due to COW, yes.


> which point the kernel creates a copy of the page written to. This is done
> through the function do_wp_page which in turn calls cow_user_page.

Yes.


> I created a simple program, where the child and parent process write to a
> variable differently. I have instrumented the kernel at cow_user_page. On
> inserting the kprobe module and running the fork program, I do not get a
> call to cow_user_page. I had several questions:
> 1. Does this mean that the kernel is not doing COW optimization?

It means it is not breaking COW where you expect.


> 2. Is COW enabled by default, if not, how do we turn it on?

It is.


> 3. Any other point in the kernel, where cow is done, other than
> cow_user_page?

If one process exits before the other writes to it, that condition
will be noticed in do_wp_fault and a copy can be avoided. The kernel
would still be doing the COW optimisation without ever actually
making a copy.


> Regarding page initialization, if I understand it correctly, the kernel
> calls get_zeroed_page when it has to allocated a zeroed page, once again in
> my kernel module, I have probes the kernel at get_zeroed_page, but get no
> calls, even on running the system for a long time, any other place where
> the kernel gets zeroed pages to return the applications ?

No, it doesn't look like it calls get_zeroed_page for userspace memory
allocation. Try alloc_zeroed_user_highpage_movable, alloc_page_vma etc.

