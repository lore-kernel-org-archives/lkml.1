Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYFZTtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYFZTtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYFZTtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:49:36 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:41956 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbYFZTtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:49:35 -0400
Message-ID: <4863F2CC.1030907@linux.vnet.ibm.com>
Date: Thu, 26 Jun 2008 16:49:32 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [RFC/PATCH 0/3] sched: allow arch override of cpu power
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
In-Reply-To: <1213835374-10868-1-git-send-email-ntl@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

Nathan Lynch wrote:
> There is an "interesting" quality of POWER6 cores, which each have 2
> hardware threads: assuming one thread on the core is idle, the primary
> thread is a little "faster" than the secondary thread.  To illustrate:
>   
I found this feature interesting and decided to do some tests.
After some tests I found that the example you post really runs fast in 
the first CPU, but a more "elaborated" application runs slower on the 
first CPU.
Here is a small example:

# taskset 0x1 time -f "%e,  %U, %S" ./a.out ; taskset 0x2 time -f "%e, 
%U, %S" ./a.out
10.77,  10.72, 0.01
10.53, 10.48, 0.01

# taskset 0x2 time -f "%e,  %U, %S" ./a.out ; taskset 0x1 time -f "%e, 
%U, %S" ./a.out
10.55,  10.50, 0.01
10.77, 10.72, 0.01

# cat calc.c
#include <stdio.h>

int main(){
    int j = 0;
    float i = 42;
   
    srand(123);
    while (j++ < 100000000){
        i = i*i + i;
        i = i/2 + random(2);
    }

    printf("%d\n", i);
    return 0;
}
# cat /proc/cpuinfo
processor    : 0
cpu        : POWER6 (architected), altivec supported
clock        : 5000.001000MHz
revision    : 3.2 (pvr 003e 0302)

processor    : 1
cpu        : POWER6 (architected), altivec supported
clock        : 5000.001000MHz
revision    : 3.2 (pvr 003e 0302)
...

Note that the IRQ are balanced among the 8 CPUs, and the machine is idle.
Do you know why I get this difference? Something wrong with the test?

Thanks

- 
Breno Leitao
Linux Technology Center Brazil
Phone: +55-16-8115-3915 (T/L: 839-1293)
leitao@linux.vnet.ibm.com

