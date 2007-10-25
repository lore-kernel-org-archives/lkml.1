Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXJYX3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXJYX3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXJYX3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:29:36 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:42212 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753476AbXJYX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:29:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Wuue+Dknu57q7FqrlUWVl6hLUK8/aih3cssc+e5w2cl9Npu9R08iRo3kKckx6p6ZGWLA6FpkQzXLTOjFzkULQ5GP66IhrcJibVhrbXYBX0LdkTvrTrYNI2WC0SSQ0Y/fgAOdbG1akc/oWbZ0MleYiIL9d1/cyIs9S/IC9PhVarE=  ;
X-YMail-OSG: OO.PV8UVM1luw4IPVs0.p.INU1ZL2i4kqugN35HZnnm834P0.T3Cd.gwTTkLWs566QC6jebOwA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: davids@webmaster.com, "Torvalds, Linus" <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 09:22:54 +1000
User-Agent: KMail/1.9.5
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKMEEDHMAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEEDHMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260922.54428.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you retain cc list, please?

On Friday 26 October 2007 07:42, David Schwartz wrote:
> 	I asked a collection of knowledgeable people I know about the issue. The
> consensus is that the optimization is not permitted in POSIX code but that
> it is permitted in pure C code. The basic argument goes like this:
>
> 	To make POSIX-compliant code even possible, surely optimizations that add
> writes to variables must be prohibited. That is -- if POSIX prohibits
> writing to a variable in certain cases only the programmer can detect, then
> a POSIX-compliant compiler cannot write to a variable except where
> explicitly told to do so. Any optimization that *adds* a write to a
> variable that would not otherwise occur *must* be prohibited.
>
> 	Otherwise, it is literally impossible to comply with the POSIX requirement
> that concurrent modifications and reads to shared variables take place
> while holding a mutex.

Now all you have to do is tell this to the gcc developers ;)


> 	The simplest solution is simply to ditch the optimization. If it really
> isn't even an optimization, then that's an easy way out.

For some things, I'd expect it will be an optimisation, which is why
they're even doing it. Even on x86 perhaps, where they do tricks with
sbb/adc. If it avoids an unpredictable branch, it could help. Actually
a silly microbenchmark shows it's worth 10% to do a cmov vs an
unpredictable conditional jump, but another 2.5% to do the adc and
unconditional store (which is the problematic bit).

And for unshared things like local variables where their address
hasn't escaped, it's fine.

Still, I guess that for most non-stack variables, you would actually
_want_ to do a cmov rather than the adc, even in a single threaded
program. Because you don't want to touch the cacheline if possible,
let alone dirty it.
