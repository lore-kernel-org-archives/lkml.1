Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYIBEjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYIBEjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 00:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYIBEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 00:39:12 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:31079 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750982AbYIBEjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 00:39:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dx3JArnhbbFq2bXZSPhV9GlmXhYxAtZozmYK6q5DvdFapAq9OS3RZYLHUKNsFS1lyje/ggGLm0IMIUBqRSRWOjqcqkYclhqIguEGm4fkie59VLx8grBqQIYM4GIe8/vQ8VOq//i3gmZM1CMzE2vSBbxUKYqscc116eHCVBBnIzU=  ;
X-YMail-OSG: XaFTcYUVM1kHOUFzVCuO0xoLdBRced93EH94UwN19LrChPBetpHbA_YnPHjdcIaTqhiysfGX1WUbxi8XJn.0bOI3tG8o3iH2ofeg6NIX8uosnZL7MD88wRSJqyTsfLQDVmw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "CHADHA,VINEET" <vineet@ufl.edu>
Subject: Re: TLB evaluation for Linux
Date: Tue, 2 Sep 2008 14:39:00 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu>
In-Reply-To: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809021439.00484.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008 14:12, CHADHA,VINEET wrote:
> Hi,
>
> I have been working to evaluate TLB performance for Linux O/S and
> virtualized workloads(such as Xen) in a Full system simulator(e.g.
> simics). While my evaluation is in nascent stage, I do notice that
> most of the IPIs in multi-core environments cause complete TLB
> Flush.
>
> I want to evaluate cost of TLB shootdown including re-population
> vs. each entry shootdown (invlpg). While a similar study has been
> done in other kernels (e.g. L4 kernel), I am not aware if it has
> been done for Linux O/S.

This is a very interesting area to investigate. Do you have a link to
any of the existing studies?


> Are there hooks or patches to test or evaluate TLB performance.
> Specifically, I would like to know where to make changes in Linux
> kernel to support each entry shootdown.

The main thing I guess is to look at tlb_flush(), called by tlb_flush_mmu
when unmapping user virtual memory, which on x86 is going to call
flush_tlb_mm, which flushes the entire tlb.

It would need a bit of reworking of things in order to store the virtual
address corresponding to each page in the struct mmu_gather, and then
deciding to branch off to do multiple invlpg if you have only a small
number of pages to be flushed. I'd suggest the easiest way to get
something working on x86 would be to modify the asm-generic infrastructure
(ignore other architectures for the time being).

You will also have to rework the IPI flushing scheme so that it can handle
more than one flush_va for invlpg invalidations.

After you get all this done, you could also look at applying similar
heuristics to flush_tlb_range. This one should be much easier at this point,
but it is used in fewer places (eg. mprotect).
