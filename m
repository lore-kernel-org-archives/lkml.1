Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYCQCqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYCQCqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYCQCpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:45:53 -0400
Received: from n65.bullet.mail.sp1.yahoo.com ([98.136.44.190]:32163 "HELO
	n65.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754135AbYCQCpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:45:52 -0400
X-Yahoo-Newman-Id: 930923.609.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oNSAIHmsvfEmSy7OsVG1DVHIJrggpH3YzXzeMh/yhJYZXH3l0tzSYZFKKV4isklgEa3ZqVvDXOpHLBZ5ivubdqzOCytwms09do5J3BmmwZMvRtda5mhQ2Piqiscn43CWunUalfXXnLl+yMrLPYUCRYjpqds2nP4G03e8f3mbvhs=  ;
X-YMail-OSG: vIycfoQVM1m4D9MyK0JHG_B.UEe89YsCp2dnWn3ZVAkGGTZ3aYGCJMB6lOV5B8sF9xa50RqqQA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH v1] change likeliness accounting
Date: Mon, 17 Mar 2008 13:45:13 +1100
User-Agent: KMail/1.9.5
Cc: dwalker@mvista.com, lkml <linux-kernel@vger.kernel.org>
References: <47D9B35C.9@tiscali.nl>
In-Reply-To: <47D9B35C.9@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171345.14164.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2008 10:06, Roel Kluin wrote:
> In the patch below I propose some changes to the likely/unlikely
> accounting. ---
> In struct likeliness: store __builtin_return_address in 'caller', rather
> than __FILE__ and __func__, and combine 'type' and 'line' into one 'label'.
>
> The __check_likely macro performs some functionality originally in
> do_check_likely(): The first check for LP_UNSEEN bit, the increment of the
> experienced likely-count. do_check_likely() looses its parameter and return
> value. I added a __builtin_expect() to make use of the expectation.
>
> The likely diplay changes: now +/- denotes whether expectation fails in
> less than 0.01% of the tests rather than whether more unexpected than
> expected were encountered. __FILE__ is no longer displayed in output.

0.01%, so 1 time every 10 000 tests.

That seems pretty excessive. If the 9 999 tests which were taken
correctly each saved only 0.1 cycle due to the likely annotation,
then that would be implying the same likely annotation adds 1 000
cycles to the cost of the branch when taken that way.

In practice, I'd say it is probably just going to cost an extra
icache miss, another jump, and maybe a cycle here or there... 100
cycles at worst. And the benefit might also be larger than 0.1 cycle
because it could save some icache and reduce cold branch mispredicts.
It will also make the next gcc use jumps instead of cmov, which
reduces hazards to the out of order engine for example.

I think 1-5% is more reasonable a number if I were to pull one out of
my hat.

