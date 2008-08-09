Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbYHICnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbYHICnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYHICnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:43:05 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:54610 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbYHICnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:43:04 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sat, 9 Aug 2008 04:43:00 +0200
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, viro@zeniv.linux.org.uk,
       vegard.nossum@gmail.com
References: <200807171653.59177.wolfgang.walter@stwm.de> <489C97FB.2030408@zytor.com> <20080809014925.GA26529@gondor.apana.org.au>
In-Reply-To: <20080809014925.GA26529@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808090443.00597.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Herbert Xu wrote:
> On Fri, Aug 08, 2008 at 12:01:15PM -0700, H. Peter Anvin wrote:
> >
> > It's technically overkill, if (and only if!) these instructions don't 
> > actually touch the SSE state (most likely they're using the SSE 
> > pipeline, and need this stuff to deal with power management issues.)
> 
> Yes the PadLock uses the SSE pipeline, but doesn't touch any
> of the state.
> 
> > However, overkill is a good way to make sure something is dead. 
> > Applying the patch will make sure we fix the regression, and we can 
> > worry about optimizing this further post-2.6.27.
> 
> Do we really need the FPU changes right now? I'd prefer for that
> to be backed out until a proper solution is found.  Disabling
> preemption around crypto is really bad for scheduling latency.
> 

These FPU changes are already in 2.6.26. Undoing them, would that be accepted 
for 2.6.26 stable?

Maybe the following solution would be possible: if a processor with padlock is 
detected the memory for xstate is always allocated when the thread is created 
instead "lazy"?

Or would it be possible to change __switch_to(): bevor calling __unlazy_fpu() 
check if xstate is NULL, if yes, clear TS_USEDFPU and math-state?


As I wrote in my other mail: 2.6.26 with the patch seems to perform rather 
well with ipsec. Network latency and bandwidth seem completely unchanged 
compared to 2.6.15.13 as far as I can see yet.

But this is of course not a good test for kernel latency itself. As we don't 
have any destops based on VIA C3 (and these using padlock) I can't really 
test this (even if I set one up I don't know how it used to feel with 
2.6.25 :-) ). 

But I doubt that a lot of people use it as a desktop together with a VIA C3 
and ipsec. If they would they must see this crash.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196-276
Fax: +49 89 38196-144
wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
