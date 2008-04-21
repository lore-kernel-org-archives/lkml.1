Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYDUUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYDUUcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYDUUcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:32:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:49582 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYDUUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:32:11 -0400
Message-ID: <ab3f9b940804211332i2e75c19co286d7ba1c69ca99b@mail.gmail.com>
Date: Mon, 21 Apr 2008 13:32:06 -0700
From: "Tom May" <tom@tommay.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080418170129.A8DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080417182121.A8CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <ab3f9b940804171223m722912bfy291a2c6d9d40b24a@mail.gmail.com>
	 <20080418170129.A8DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 3:07 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:

>  I investigated again and found 2 problem in your test program.
>
>  1. text segment isn't locked.
>
>    if strong memory pressure happned, kernel may drop program text region.
>    then your test program suddenly slow down.
>
>    please use mlockall(MCL_CURRENT) before large buffer allocation.

Using mlock does enable the program to respond faster (and/or the
kernel doesn't have to find memory to fault the page in) and solves
the problem for this simple test program.  I think we're thinking of
the solution in two different ways: you want the program to react more
quickly or be "nicer", and I want the kernel to give notification
early enough to allow time for things that can (and do) happen when
things aren't so nice. I realize that in extreme circumstances oom may
be unavoidable, but a threshold-based notification, in addition to the
current /dev/mem_notify mechanism, would help avoid extreme
circumstances.  I'm going to look into doing this.

>  2. repeat open/close to /proc/meminfo.
>
>    in the fact, open(2) system call use a bit memory.
>    if call open(2) in strong memory pressure, doesn't return until
>    memory freed enough.
>    thus, it cause slow down your program sometimes.

This should be fine; I intentionally do the open/read/write/close
after freeing memory.

>  attached changed test program :)
>  it works well on my test environment.

I made your changes to my program (I'm using clone since I don't have
a pthreads library on my device, and I left PAGESIZE at 4K instead of
64K), and having memory locked does avoid oom in this case, but
unfortunately I don't think it's a general solution that will work
everywhere in my system.  (Although I'm going to try it.)

Thanks,
.tom
