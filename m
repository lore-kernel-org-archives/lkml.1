Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZCAOU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZCAOU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZCAOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:20:14 -0500
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:37057 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752416AbZCAOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:20:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z1EhYz8Vpt2lPXcClkP68uoKMyDJ6J7VzBsWV4RDWgbCIOBp0aKO5ZCr9CcSwEBVNQJ3//aZBqj0etDcd3es161DYIOtUXgjzrw0N0eR20AE2kbZ+7oaeMlHky8frZnkz1RNqg+zKHC7GKl9XLJjaE+a/lggytckGdYSza68224=  ;
X-YMail-OSG: XxXpKvYVM1mvQ..RdvFw9NIsLpStgoo8KDMoUlkA9R1ihjb1XPpZUooohc9XktTJ3C.uwi2NdfIQol1XpK4qaGQEPY.i2WZ7jCjjag1FgQ7CWgcDLiWbfgDtIqUZAWjm_luZUPbZ78z4wUJVZTamYj3MKQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Mon, 2 Mar 2009 01:19:33 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <20090228182759.GA28865@elte.hu> <alpine.LFD.2.00.0902281041160.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902281041160.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903020119.34455.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 March 2009 05:52:19 Linus Torvalds wrote:
> On Sat, 28 Feb 2009, Ingo Molnar wrote:
> > OTOH, given how draconian non-temporal stores are, i'm leaning
> > towards removing them from the x86 code altogether. If it matter
> > to performance somewhere it can be reintroduced, based on really
> > well backed up numbers.
>
> It would be interesting to see if we could instead base the decision on
> what we really do care about, namely going to do IO.
>
> And the thing is, in this path we _do_ kind of know that. The caller
> (normally generic_perform_write) already does that whole
> balance_dirty_pages_ratelimited() thing.

>
> So rather than passing in the "total_size" thing, we _could_ pass in
> something that is based on
>
>  - are we O_DIRECT? If so: use uncached

Zero copies in that case :) O_SYNC, you mean.


>  - perhaps: are we really _really_ large? If so: use uncached, we know the
>    caches aren't going to capture it.

But how large, and which caches? I wouldn't expect very many apps at all
to pass buffers larger than even quite small LLC sizes.


>  - are we starting writeout due to dirty page balancing: if so, use
>    uncached.

Although that should tend to write out oldest written data, wheras
the newly written data might still benefit from being warm in cache
(eg. in the cpp|cc|as|ld case).


> But on the other hand, I could personally certainly also imagine just not
> doing that whole uncached thing at all. Myself, I tend to care about the
> peformance of the cached case much more than some odd iozone thing. But
> others will have different priorities..

FWIW I agree with you. rep mov I think gives the CPU a good window into
proceedings and usually should do a good job.

