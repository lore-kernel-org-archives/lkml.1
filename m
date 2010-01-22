Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934Ab0AVDRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0AVDRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890Ab0AVDRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:17:20 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:37771 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab0AVDRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=IjsUTRBJPo19RBS2EgOl4DcoBbTeqsOw6r54a6NCRMSRltHd0PdjAcXGBapdkcnY+M
         /RQfwDjoy9xiibCrnhVF4ULXqoT4RN0V/wmkZX8fBild78jG/EK9levqzrKTEPx0FJwP
         PEf+GKsllbeLrNXRfU9oeSdK2NGKKphFk3+0c=
From: Don Mullis <don.mullis@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, david@fromorbit.com,
       dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box>
Date: Thu, 21 Jan 2010 19:17:15 -0800
In-Reply-To: <20100121175914.GA8910@basil.fritz.box> (Andi Kleen's message of
	"Thu, 21 Jan 2010 18:59:14 +0100")
Message-ID: <87vdeu96bo.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Wed, Jan 20, 2010 at 08:51:26PM -0800, Don Mullis wrote:
>> The use of list_sort() by UBIFS looks like it could generate long
>> lists; this alternative implementation scales better, reaching ~3x
>> performance gain as list length approaches the L2 cache size.
>
> If this can really be called with long lists 
> the function likely needs (optional) need_resched()s
> Otherwise it could ruin scheduling latencies.
>
> -Andi

Being just a dumb library routine, list_sort() has no idea what context
it's been called in, how long a list a particular client could pass in,
nor how expensive the client's cmp() callback might be.

The cmp() callback already passes back a client-private pointer.
Hanging off of this could be a count of calls, or timing information,
maintained by the client.  Whenever some threshold is reached, the
client's cmp() could do whatever good CPU-sharing citizenship required.

This doesn't address the final O(n) pass over the list to restore the
back links.  So the cost of that pass would dictate the upper limit on
list length for a client already using the cmp() call-counting/timing
trick to break up the earlier compare-and-merge passes.

If that's not good enough, a more complicated solution would be
required.  But I'm hoping we don't need to go there yet.
