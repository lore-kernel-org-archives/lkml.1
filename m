Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbXBDM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbXBDM6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXBDM6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:58:41 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:40462 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbXBDM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:58:40 -0500
Message-ID: <45C5D7AD.9080704@joow.be>
Date: Sun, 04 Feb 2007 13:55:09 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: cycle timer read extension for	raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de>	<45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de> <45C49A88.4050809@joow.be> <45C4AAFA.3050208@s5r6.in-berlin.de>
In-Reply-To: <45C4AAFA.3050208@s5r6.in-berlin.de>
Content-Type: multipart/mixed;
 boundary="------------090405030401010502060006"
X-DCC-scarlet.be-Metrics: oola 20001; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090405030401010502060006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Stefan Richter wrote:
> Pieter Palmers wrote:
>> Stefan Richter wrote:
> ...
>>>   - Fix integer overflow.
>> I had to use 1000000ULL instead of USEC_PER_SEC to avoid weird behavior.
> 
> OK, I'll change that and will wait for...
> 
>> I can't test it right now, but I'll report later.
> 
> ...your and Dan's ACK before I commit the patch.

Stefan,

I tested the patches as posted on bugzilla, and it looks like it is 
working fine.

I attached a test program I used while writing/debugging the patches. 
Might be useful for other people to test if this works correctly.

Compile:
$ gcc -g -o ctr_test -lraw1394 ctr_test.c

Run:
$ ./ctr_test
libraw1394 Cycle Timer API test application
using port 0
init rate=24.5837

Local time: 1170593509294313us, 1170593509294.313ms (approx 38year, 
20day since epoch)
CycleTimer:  67s, 2323cy, 1894ticks
  rate:  24.583702ticks/usec

Local time: 1170593510294462us, 1170593510294.462ms (approx 38year, 
20day since epoch)
CycleTimer:  68s, 2328cy, 2044ticks
  rate:  24.587107ticks/usec


The rate should be something around 24.576.
Since epoch is somewhere around 1970, the approx 38 years looks rather 
correct.

Greets,

Pieter

--------------090405030401010502060006
Content-Type: text/x-csrc;
 name="ctr_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctr_test.c"

/*   Parts of this are originally from:
 *
 *   FreeBob = Firewire (pro-)audio for linux
 *
 *   http://freebob.sf.net
 *
 *   Copyright (C) 2005,2006,2007 Pieter Palmers <pieterpalmers@users.sourceforge.net>
 *
 *   This program is free software {} you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation {} either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY {} without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program {} if not, write to the Free Software
 *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

/*
compile:
gcc -g -o ctr_test -lraw1394 ctr_test.c
*/


#include <libraw1394/raw1394.h>
#include <stdio.h>
#include <errno.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <inttypes.h>

// Some configuration constants 
#define CC_SLEEP_TIME_AFTER_DLL_UPDATE    2000
#define CC_DLL_COEFF     (0.0001)
#define CC_INIT_MAX_TRIES 10
#define USECS_BETWEEN_PRINT (1000000LLU)

// Definitions and utility macro's to handle the ISO cycle timer

#define CYCLES_PER_SECOND   8000u
#define TICKS_PER_CYCLE     3072u
#define TICKS_PER_SECOND    24576000u
#define TICKS_PER_USEC     (TICKS_PER_SECOND/1000000.0)

#define CYCLE_COUNTER_GET_SECS(x)   ((((x) & 0xFE000000) >> 25))
#define CYCLE_COUNTER_GET_CYCLES(x) ((((x) & 0x01FFF000) >> 12))
#define CYCLE_COUNTER_GET_OFFSET(x)  ((((x) & 0x00000FFF)))
#define CYCLE_COUNTER_TO_TICKS(x) ((CYCLE_COUNTER_GET_SECS(x)   * TICKS_PER_SECOND) +\
                                   (CYCLE_COUNTER_GET_CYCLES(x) * TICKS_PER_CYCLE ) +\
                                   (CYCLE_COUNTER_GET_OFFSET(x)            ))

#define CYCLE_COUNTER_UNWRAP_TICKS(x) ((x) \
                                       + (127 * TICKS_PER_SECOND) \
                                       + (CYCLES_PER_SECOND * TICKS_PER_CYCLE) \
                                       + (TICKS_PER_CYCLE) \
                                      )

// globals
uint64_t m_lastmeas_usecs;
unsigned int m_cyclecounter_ticks;
double m_ticks_per_usec;

// signal handler
int keep_running=1;

static void sighandler (int sig)
{
	keep_running = 0;
}

// DLL functions
int init_dll(uint64_t usecs1, unsigned int ticks1,
             uint64_t usecs2, unsigned int ticks2) {
    double rate=0.0;
    unsigned int delta_ticks;
    
    if (ticks2 > ticks1) {
        delta_ticks=ticks2 - ticks1;
    } else { // wraparound
        delta_ticks=CYCLE_COUNTER_UNWRAP_TICKS(ticks2) - ticks1;
    }
    
    int delta_usecs=usecs2-usecs1;
    
    rate=((double)delta_ticks/(double)delta_usecs);
    
    // update the internal values
    m_cyclecounter_ticks=ticks2;
    m_lastmeas_usecs=usecs2;

    m_ticks_per_usec=rate;
    
    printf("init rate=%6.4f\n", rate);
}

int update_dll(uint64_t new_usecs, unsigned int new_ticks) {
    uint64_t prev_usecs=m_lastmeas_usecs;
    unsigned int prev_ticks=m_cyclecounter_ticks;
    
    // the difference in system time
    int delta_usecs=new_usecs-prev_usecs;

    // the measured cycle counter difference
    long unsigned int delta_ticks_meas;
    if (new_ticks > prev_ticks) {
        delta_ticks_meas=new_ticks - prev_ticks;
    } else { // wraparound
        delta_ticks_meas=CYCLE_COUNTER_UNWRAP_TICKS(new_ticks) - prev_ticks;
    }
    
    // the estimated cycle counter difference
    unsigned int delta_ticks_est=(unsigned int)(m_ticks_per_usec * ((double)delta_usecs));
    
    // the measured & estimated rate
    double rate_meas=((double)delta_ticks_meas/(double)delta_usecs);
    double rate_est=((double)m_ticks_per_usec);
    
    int diff=(int)delta_ticks_est;
    
    // calculate the difference in predicted ticks and
    // measured ticks
    diff -= delta_ticks_meas;
    
    
    if (diff > 24000 || diff < -24000) { // approx +/-1 msec error
        printf("Bad pred: diff=%d, dt_est=%u, dt_meas=%u, d=%dus, err=%fus\n",
        diff, delta_ticks_est, delta_ticks_meas, delta_usecs, (((double)diff)/24.576)
        );
    }
    
    // calculate the error 
    double err=rate_meas-rate_est;
    
    // first order DLL update to obtain the rate.
    m_ticks_per_usec += CC_DLL_COEFF*err;
    
    // update the internal values
    m_cyclecounter_ticks += delta_ticks_est;
    // if we need to wrap, do it
    if (m_cyclecounter_ticks > TICKS_PER_SECOND * 128) {
            m_cyclecounter_ticks -= TICKS_PER_SECOND * 128;
    }

    m_lastmeas_usecs = new_usecs;

    return 0;
}

// main
int32_t main(int32_t argc, char **argv)
{

    int port=0;

    raw1394handle_t handle;
    uint64_t last_local_time=0;
    struct raw1394_cycle_timer ctr;
    struct raw1394_cycle_timer ctr2;
    int err;

    printf("libraw1394 Cycle Timer API test application\n");

    if (argc==2) {
        port = atoi(argv[1]);
    }

    printf("using port %d\n",port);

    // get handle
    handle = raw1394_new_handle_on_port(port);
    if (handle == NULL) {
        perror("raw1394_new_handle");
        return -1;
    }
    
    // register signal handler
    signal (SIGINT, sighandler);
    signal (SIGPIPE, sighandler);
    
    // init the DLL
    err=raw1394_read_cycle_timer(handle, &ctr);
    if(err) {
        perror("raw1394_read_cycle_timer");
    }

    usleep(CC_SLEEP_TIME_AFTER_DLL_UPDATE);

    err=raw1394_read_cycle_timer(handle, &ctr2);
    if(err) {
        perror("raw1394_read_cycle_timer");
    }

    init_dll(ctr.local_time,CYCLE_COUNTER_TO_TICKS(ctr.cycle_timer),
             ctr2.local_time,CYCLE_COUNTER_TO_TICKS(ctr2.cycle_timer));

    usleep(CC_SLEEP_TIME_AFTER_DLL_UPDATE);

    printf("\n");
    // start the monitor loop
    while (keep_running) {
        ctr.local_time=0;

        err=raw1394_read_cycle_timer(handle, &ctr);
        if(err) {
            perror("raw1394_read_cycle_timer");
        } else {
            uint64_t local_time_usec=ctr.local_time;
            double local_time_msec=(double)local_time_usec;
            unsigned int offset=CYCLE_COUNTER_GET_OFFSET(ctr.cycle_timer);
            unsigned int cycles=CYCLE_COUNTER_GET_CYCLES(ctr.cycle_timer);
            unsigned int secs=CYCLE_COUNTER_GET_SECS(ctr.cycle_timer);
            
            local_time_msec /= 1000.0;
            
            update_dll(ctr.local_time,CYCLE_COUNTER_TO_TICKS(ctr.cycle_timer));
            
            if ((ctr.local_time - last_local_time) > USECS_BETWEEN_PRINT) {
                const uint64_t usecs_per_day=24LLU*60LLU*60LLU*1000000LLU;
                const uint64_t usecs_per_year=356LLU*usecs_per_day;

                uint64_t years=local_time_usec/usecs_per_year;
                uint64_t days=local_time_usec%usecs_per_year;
                days /= usecs_per_day;
                
                printf("Local time: %16lluus, %16.3fms (approx %2lluyear, %3lluday since epoch)\n",
                    local_time_usec,local_time_msec, years, days);
                printf("CycleTimer: %3us, %4ucy, %4uticks\n",secs,cycles,offset);
                printf(" rate: %10.6fticks/usec\n\n",m_ticks_per_usec);

                last_local_time=ctr.local_time;
            }
        }

        usleep(CC_SLEEP_TIME_AFTER_DLL_UPDATE);
    }

    return 0;
}

--------------090405030401010502060006--
