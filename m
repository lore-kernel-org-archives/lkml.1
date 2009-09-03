Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZICUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZICUpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932243AbZICUpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:45:52 -0400
Received: from claw.goop.org ([74.207.240.146]:41327 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbZICUpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:45:52 -0400
Message-ID: <4AA02B02.7080101@goop.org>
Date: Thu, 03 Sep 2009 13:45:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com>
In-Reply-To: <4AA02687.9080406@zytor.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/09 13:26, H. Peter Anvin wrote:
> With the new zero-based percpu segment, it seems we should be able to
> subsume the stack protector into the percpu segment and reference both
> via %gs -- we just have to reserve the first 24 bytes of the segment,
> and being able to reduce the number of segments we need in the kernel is
> good for multiple reasons.
>
> Tejun - am I missing something why that would be hard or impossible?
>   

Two problems:

    * gcc generates %gs: references for stack-protector, but we use %fs
      for percpu data (because restoring %fs is faster if it's a null
      selector; TLS uses %gs).  I guess we could use %fs if
      !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it (though that
      has some fiddly ramifications for things like ptrace).
    * The i386 percpu %fs base is offset by -__per_cpu_start from the
      percpu variables, so we can directly refer to %fs:per_cpu__foo. 
      I'm not sure what it would take to unify i386 to use the same
      scheme as x86-64.

Neither looks insoluble.

    J
