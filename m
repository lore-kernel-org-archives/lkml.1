Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbXGWQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbXGWQC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXGWQCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:02:20 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:33567 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbXGWQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:02:19 -0400
Date: Mon, 23 Jul 2007 18:04:02 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070723160402.GA4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185197716.14697.244.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS - definitive version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 02:35:16PM +0100, David Woodhouse wrote:
> 
> s/Documentaion/Documentation/ in the last line of Documentation/pps/pps.txt

Fixed.

> Please feed it to scripts/checkpatch.pl -- you can ignore all the
> warnings about lines greater than 80 characters, and the complete crap
> about "declaring multiple variables together should be avoided", but
> some of what it points out is valid. Including the one about 'volatile'

Ok, I'll do it.

> -- your explanation lacked credibility. If you really need 'volatile'
> then put it at the places you actually need it; not the declaration of
> the structure.

About this debate, please, take a look at the pps_event() function:

void pps_event(int source, int event, void *data)
{
        struct timespec __ts;
        struct pps_ktime ts;

        /* First of all we get the time stamp... */
        getnstimeofday(&__ts);

        /* ... and translate it to PPS time data struct */
        ts.sec = __ts.tv_sec;
        ts.nsec = __ts.tv_nsec;

        if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0 ) {
                pps_err("unknow event (%x) for source %d", event, source);
                return;
        }

        /* We wish not using locks at all into this function... a possible
         * solution is to check the "info" field against the pointer to
         * "dummy_info".
         * If "info" points to "dummy_info" we can return doing nothing since,
         * even if a new PPS source is registered by another CPU we can
         * safely not register current event.
         * If "info" points to a valid PPS source's info data we can continue
         * without problem since, even if current PPS source is deregistered
         * by another CPU, we still continue writing data into a valid area
         * (dummy_info).
         */
        if (pps_source[source].info == &dummy_info)
                return;

        /* Must call the echo function? */
        if ((pps_source[source].params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
                pps_source[source].info->echo(source, event, data);

        /* Check the event */
        pps_source[source].current_mode = pps_source[source].params.mode;
        if (event & PPS_CAPTUREASSERT) {
                /* We have to add an offset? */
                if (pps_source[source].params.mode & PPS_OFFSETASSERT)
                        pps_add_offset(&ts,
                                &pps_source[source].params.assert_off_tu);

                /* Save the time stamp */
                pps_source[source].assert_tu = ts;
                pps_source[source].assert_sequence++;
                pps_dbg("capture assert seq #%u for source %d",
                        pps_source[source].assert_sequence, source);
        }
        if (event & PPS_CAPTURECLEAR) {
                /* We have to add an offset? */
                if (pps_source[source].params.mode & PPS_OFFSETCLEAR)
                        pps_add_offset(&ts,
                                &pps_source[source].params.clear_off_tu);

                /* Save the time stamp */
                pps_source[source].clear_tu = ts;
                pps_source[source].clear_sequence++;
                pps_dbg("capture clear seq #%u for source %d",
                        pps_source[source].clear_sequence, source);
        }

        pps_source[source].go = ~0;
        wake_up_interruptible(&pps_source[source].queue);
}

The problems should arise at:

	if (pps_source[source].info == &dummy_info)
		return;

but as explained into the comment there should be no problems at
all...

About "where" to put the "volatile" attribute I don't understand what
you mean... such attribute is needed (IMHO) for "assert_sequence"&C,
where should I put it? :-o
 
> You've also reverted to structures which vary between 32-bit and 64-bit
> userspace, because they use 'long' and 'struct timespec', but you
> haven't provided the compat_* routines which are then necessary.

As already suggested I used fixed size variables. See the new struct
"struct pps_ktime".

> +typedef int pps_handle_t;              /* represents a PPS source */
> +typedef unsigned long pps_seq_t;       /* sequence number */
> +typedef struct ntp_fp ntp_fp_t;                /* NTP-compatible time stamp */
> +typedef union pps_timeu pps_timeu_t;   /* generic data type to represent time s
> tamps */
> +typedef struct pps_info pps_info_t;    
> +typedef struct pps_params pps_params_t;
> 
> Don't do this for the structures. It's dubious enough for the integer
> types.

Such code is for userland since RFC2783 requires such types... I moved
all userland code into Documentation/pps/timepps.h which can be used
by userland programs whose require RFC compatibility.

I'll post a new patch ASAP.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
