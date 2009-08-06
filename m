Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZHFLkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZHFLkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZHFLkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:40:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZHFLko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:40:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=WYN4pqD3Wlp2pvjFy3QS+pUXW2E4PRHNPJsfZiyJM9rS0Ab0oPcGYFHdgrDE7doUm
	vQ2KS3odWe3Lc04Jn0uTw==
MIME-Version: 1.0
In-Reply-To: <20090806112450.GF26446@hawkmoon.kerlabs.com>
References: <20090803194555.GA10158@us.ibm.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <20090806112450.GF26446@hawkmoon.kerlabs.com>
Date: Thu, 6 Aug 2009 04:40:37 -0700
Message-ID: <6599ad830908060440g2f6cbed6xdc54c7096cd3745e@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 4:24 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>
> You meant signal_struct, right? sighand_struct can be shared by several
> thread groups, while signal_struct can't.
>

No, I meant sighand_struct. I realise that it *can* be shared between
processes, but I didn't think that NPTL actually did so. (Are there
common cases of this happening?) And in cases where it was shared, it
wouldn't affect correctness, but simply create the potential for a
little more contention.

I agree that signal_struct might in principle be a better place for
it, but the first cacheline of signal_struct appears to be occupied
with performance-sensitive things (a couple of counters and a queue
used in do_wait()) already, whereas the first cacheline of
sighand_struct only appears to be used incremented/decremented during
fork/exit, and when delivering a bunch of mostly-fatal signals.

But having said that, if having it in signal_struct isn't considered a
potential performance hit, it would be fine there too.

Paul
