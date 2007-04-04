Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXDDGas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXDDGas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXDDGas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:30:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:58481 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbXDDGao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MIo9MUHeTMnjuuUSu88Z5+FZ1R3cqre9sy+0hFXa2rB6sUfLO6LIGJoIKzd6U8pXz8M3s6jHnUW1/pZF9HR5iaqGaOEU1NDTcn8Sg3GL9SfPHv7DKDn20PPQoajuu2d2hMyJ7HkOJKUpmxpV5Mw9wWlw7empjXXFqhyKcnkSUaU=
Message-ID: <84144f020704032330j719b2e14yb37bfa0080718b1b@mail.gmail.com>
Date: Wed, 4 Apr 2007 09:30:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Cc: linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <46130921.7040306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460D7F70.3090702@gmail.com> <461165FD.2010508@gmail.com>
	 <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI>
	 <461256C1.4020906@gmail.com>
	 <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0704032030470.8078@sbz-30.cs.Helsinki.FI>
	 <46129968.9000304@gmail.com>
	 <Pine.LNX.4.64.0704032124591.8078@sbz-30.cs.Helsinki.FI>
	 <46130921.7040306@gmail.com>
X-Google-Sender-Auth: cc7272a4d796946b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Rene Herman <rene.herman@gmail.com> wrote:
> Taking forever to reproduce in as far as getting the oops. The thing is
> now just locking hard each time. Will keep on trying...

Can you get anything out with sysrq-t? The original oops would be
enough to conclude it's a double-free if it weren't for this:

    if (stuffp->toc) {
           kfree(stuffp->toc);
           stuffp->toc = NULL;
    }

While the code is obviously unsafe, we would have to be interrupted
between the read and the assignment, but you don't even have preempt
enabled! So I don't quite yet see where the concurrency is coming
from.

What you can do here is protect the above sequence with a spinlock,
for example, which might paper-over the double-free enough to get you
running again...

                                       Pekka
