Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0BRJxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:53:12 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44674 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0BRJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=w+HkBCO564+HI4tji99yu7bMsckXZl+eD7fqWaIZPZHB7Pvw8pDcN9YTpYwH8Spj5t
         1HitBn/pDbyfeCzA/qfiLIhTWk30/ILUpK3HG5VVMMdP7KY2ZLRxlFH2ZlPaPEEXWJlp
         LfBPub3BLn7jOE03ReWU7hzbLVQS6iEHo0zWQ=
MIME-Version: 1.0
In-Reply-To: <87eikj54wp.fsf@basil.nowhere.org>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
Date: Thu, 18 Feb 2010 10:53:06 +0100
X-Google-Sender-Auth: fd9e9c0240f8d936
Message-ID: <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You seem to have forgotten to add benchmark results that show this is
> actually worth while? And is there really any user on 32bit
> that needs 64bit atomic_t?
perf is currently the main user.
On Core2, lock cmpxchg8b takes about 24 cycles and writes the
cacheline, while movlps takes 1 cycle.
clts/stts probably wipes out the savings if we need to use it, but we
can keep TS off and restore it lazily on return to userspace.

According to http://turkish_rational.tripod.com/trdos/pentium.txt
> I'm also suspicious of your use of global register variables.
> This means they won't be saved on entry/exit of the functions.
> Does that really work?
I think it does.
The functions never change the global register variables, and thus
they are preserved.
Calls are done in inline assembly, which saves the variables if they
are actually used as parameters (the global register variables are
only visible in a portion of the C file, of course).
