Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYE1WTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYE1WTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbYE1WTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:19:18 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:43643 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbYE1WTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JfZ1uA3H/S0Kz6RIO+k6ThUxYjetrzV4+mV0DnvkQKCUDc7pqBvKSpEQymCFIZVpAXb2ewCk4LHJKoVH+1JyG6QR0gSVxLEAZr8NidTkq22hF7TNHwqEyFZEpNL6xIQ5+91t6jzQZJ8BrGuvBKHO4UZSpV7aAm3XBw4PZsTrA/E=
Message-ID: <5d96567b0805281519v7ee18eb0l27f2e4edc18af01c@mail.gmail.com>
Date: Thu, 29 May 2008 01:19:14 +0300
From: Raz <raziebe@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: mmap over HPET - 32 bit wrap arround
In-Reply-To: <83CA05F64804AF43B8F733C4ABDFAA5101384FA4@mail1.bitband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83CA05F64804AF43B8F733C4ABDFAA5101384F73@mail1.bitband.com>
	 <83CA05F64804AF43B8F733C4ABDFAA5101384FA4@mail1.bitband.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am wondering wether someone can explain how hpet behaves. The bellow
is a short program that reads from a mmaped /dev/hpet the time. I am
running it and it looks that afer ~296 seconds the counter resets . I
AM RUNNING  64bi KERNEL(2.6.18-8.el5)  and reading a 64BIT VARIABLE.
my hpet is 14MHZ, so I  am guessing a 32bit wraparound ( ~296 * 14Mhz
) =  MAX_INT . but why ?

thank  you

raz

#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>ing 6
#include <sys/mman.h>
#include <stdio.h>

struct hpet {
        uint64_t        hpet_cap;               /* capabilities */
        uint64_t        res0;                   /* reserved */
        uint64_t        hpet_config;            /* configuration */
        uint64_t        res1;                   /* reserved */
        uint64_t        hpet_isr;               /* interrupt status reg */
        uint64_t        res2[25];               /* reserved */
        union {                         /* main counter */
                uint64_t                _hpet_mc64;
                uint32_t                _hpet_mc32;
                unsigned long   _hpet_mc;
        } _u0;
        uint64_t        res3;                   /* reserved */
        struct hpet_timer {
                uint64_t        hpet_config;    /* configuration/cap */
                union {                 /* timer compare register */
                        uint64_t                _hpet_hc64;
                        uint32_t                _hpet_hc32;
                        unsigned long   _hpet_compare;
                } _u1;
                uint64_t        hpet_fsb[2];    /* FSB route */
        } hpet_timers[1];
};

struct hpet* timer;
int hpet_fd;
uint64_t resHZ;
uint64_t divisor;
#define NSEC_PER_SEC  1000000000LL
#define USEC_PER_SEC  1000000LL


int hpet_init()
{
        hpet_fd = open("/dev/hpet", O_RDONLY);
        if (hpet_fd < 0) {
                puts("This system has no accessible HPET device");
                return -1;
        }
        timer  = ( struct hpet* )mmap(NULL, 1024 ,PROT_READ,
MAP_SHARED, hpet_fd, 0);
        if ((long)timer == (-1)  ) {
                puts("This system has no mappable HPET device");
                close(hpet_fd);
                return -1;
        }
        return 0;
}

void discover_hpet_resulotion(void)
{
        uint64_t d1,d2;
        d1 = timer->_u0._hpet_mc64;
        sleep(1);
        d2 = timer->_u0._hpet_mc64;
        resHZ = d2 - d1;
        printf("HPET clock resolution %lldHZ\n",
        resHZ);
}


void calibrate_hpet(void)
{
   divisor = NSEC_PER_SEC / resHZ;
   printf("divisor=%lld ns/hpet\n", divisor);
}

uint64_t __get_cur_ns(void)
{
        return (timer->_u0._hpet_mc64*divisor);

}


uint64_t __get_cur_us(void)
{
        return __get_cur_ns()/1000;

}

int main()
{
        uint64_t d1,d2;
        if ( hpet_init() < 0 ){
                return (0);
        }
        discover_hpet_resulotion();
        calibrate_hpet();
        while(1){
                d1 = __get_cur_us();
                sleep(1);
                d2 = __get_cur_us();
                printf("cur %lldus delta=%lldus\n",
                d2,d2-d1);
        }
}




--
Raz
