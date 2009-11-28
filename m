Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZK1WUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZK1WUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZK1WUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:20:30 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58038 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZK1WU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :cc:mime-version:content-type:content-transfer-encoding:message-id;
        b=ei9qiD4jdr4IgP+vDe0MiQ6rmRT7cyGy8+/9kOPg2KXDngLQ4dSJ8jRaqsAPDM0tzZ
         KB/vfKfrJBVcJf2WSY46ju7zfE9dkq0Wemr1WfxX7KMJ0BFOn0WZuQyE18JBV4qqreDH
         BIMCarQliivFNSSTY0Mic3Q+QzvdEZTS+YLJ8=
From: Mark Veltzer <mark.veltzer@gmail.com>
Organization: veltzer.net
To: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: get_user_pages question
Date: Sun, 29 Nov 2009 00:22:17 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-686; KDE/4.3.2; i686; ; )
References: <200911090850.26724.mark.veltzer@gmail.com> <Pine.LNX.4.64.0911101613080.22198@sister.anvils> <20091128185052.GB30235@random.random>
In-Reply-To: <20091128185052.GB30235@random.random>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Nick Piggin <npiggin@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911290022.17568.mark.veltzer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 November 2009 20:50:52 you wrote:
> Hi Hugh and everyone,
> 
> On Tue, Nov 10, 2009 at 04:33:30PM +0000, Hugh Dickins wrote:
> > In fairness I've added Andrea and KOSAKI-san to the Cc, since I know
> > they are two people keen to fix this issue once and for all.  Whereas
> 
> Right, I'm sure Nick also wants to fix this once and for all (adding
> him too to Cc ;).
> 
> I thought and I still think it's bad to leave races like this open for
> people to find out the hard way. It just takes somebody to use
> pthread_create, open a file with O_DIRECT with 512byte (not page
> ....

Hello all!

First let me state that I solved my problems by simply avoiding GUP completely 
and going with a clean mmap implemenation (with the nopage version) which 
causes no problems what so ever. mmap does not suffer from all the problems 
discussed above (aside from the fact that you have to do your own book keeping 
as far as vma_open and vma_close and fault function goes...). Please correct 
me if I'm wrong...:)

The fact that I solved all my problems with mmap and the complexity of the 
proposed solutions got me thinking about GUP in more general terms. Would it 
be fair to say that mmap is much more aligned to the kernels way of doing 
things than GUP? It feels like the vma concept which is a solid one and 
probably works well for most architectures is in conflict with GUP and so is 
fork. It also feels like the vma concept is well aligned with fork which means 
in turn that mmap is well aligned with fork while GUP is not. This is a new 
conclusion for me and one which did not register back when reading the LDD 
book (I got the impression that you can pick between mmap and GUP and it does 
not really matter but now I feel that mmap is much advanced and trouble free).

Testing it out I grepped the drivers folder of a recent kernel with ONLY 26 
mentions of GUP in the entire drivers folder! The main drivers using GUP are 
scsi st and infiniband. If GUP is so unused is it really essential as an in 
kernel interface? If GUP is slowly dropped and drivers converted to mmap would 
it not simplify kernel code or at least prevent complex solutions to GUP 
problems from complicating mm code even more? Again, I'm no kernel expert so 
please don't flame me too hard if I'm talking heresy or nonsense, I would just 
like to hear your take on this. It may well be that I simply have no clue and 
so my conclusions are way too radical...

Cheers,
	Mark
