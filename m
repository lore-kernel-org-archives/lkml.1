Return-Path: <linux-kernel-owner+w=401wt.eu-S1030755AbXCNJb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755AbXCNJb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030821AbXCNJb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:31:57 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:60618 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030755AbXCNJb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:31:56 -0400
Date: Wed, 14 Mar 2007 10:31:46 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Message-ID: <20070314093146.GE24556@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <20070313213842.GA23178@enneenne.com> <20070313224817.GF22466@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313224817.GF22466@csclub.uwaterloo.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 06:48:17PM -0400, Lennart Sorensen wrote:
> 
> I have tried out 3.0.0-rc2 which seems to work pretty well so far (when

Thanks. I just posted to the linux kernel ML the last release
3.0.0. Maybe you can do a "git pull" and try it out. :)

> combined with the patches to the jsm driver I just posted).  It took soe
> work to get ntp's refclock_nmea to work though, since the patch that is
> linked to from the linuxpps page seems out of date.  Here is the patch
> that seems to be working for me, although I am still testing it.  Given
> you know the linuxpps code better perhaps you can see if it looks sane
> to you.
> 
> --- ntpd/refclock_nmea.c.ori	2007-03-13 18:38:01.000000000 -0400
> +++ ntpd/refclock_nmea.c	2007-03-13 18:44:47.000000000 -0400
> @@ -79,6 +79,7 @@
>  #define RANGEGATE	500000	/* range gate (ns) */
>  
>  #define LENNMEA		75	/* min timecode length */
> +#define LENPPS		PPS_MAX_NAME_LEN
>  
>  /*
>   * Tables to compute the ddd of year form icky dd/mm timecode. Viva la
> @@ -99,6 +100,7 @@
>  	pps_params_t pps_params; /* pps parameters */
>  	pps_info_t pps_info;	/* last pps data */
>  	pps_handle_t handle;	/* pps handlebars */
> +	int handle_created;	/* pps handle created flag */
>  #endif /* HAVE_PPSAPI */
>  };
>  
> @@ -147,6 +149,11 @@
>  	register struct nmeaunit *up;
>  	struct refclockproc *pp;
>  	int fd;
> +#ifdef PPS_HAVE_FINDPATH
> +	char id[LENPPS] = "",
> +	     path[LENPPS],
> +	     mylink[LENPPS] = "";    /* just a default device */
> +#endif	/* PPS_HAVE_FINDPATH */
>  	char device[20];
>  
>  	/*
> @@ -201,7 +208,20 @@
>  #else
>              return (0);
>  #endif
> -        }
> +        } else {
> +            struct serial_struct  ss;
> +            if (ioctl(fd, TIOCGSERIAL, &ss) < 0 ||
> +                (
> +		 ss.flags |= ASYNC_HARDPPS_CD,
> +                 ioctl(fd, TIOCSSERIAL, &ss)) < 0) {
> +                 msyslog(LOG_NOTICE, "refclock_nmea: TIOCSSERIAL fd %d, %m", fd);
> +                 msyslog(LOG_NOTICE,
> +                         "refclock_nmea: optional PPS processing not available");
> +            } else {
> +                msyslog(LOG_INFO,
> +                        "refclock_nmea: PPS detection on");
> +            }
> +	}

You should use "setserial" here. Keep in mind that the PPS source
could be _not_ connected with the serial line at all.

>  	/*
>  	 * Allocate and initialize unit structure
> @@ -238,12 +258,26 @@
>  	 * Start the PPSAPI interface if it is there. Default to use
>  	 * the assert edge and do not enable the kernel hardpps.
>  	 */
> +#ifdef PPS_HAVE_FINDPATH
> +	/* Get the PPS source's real name */
> +	//time_pps_readlink(mylink, LENPPS, path, LENPPS);

Remove unneeded code.

> +	time_pps_readlink(device, LENPPS, path, LENPPS);

Test the return value (see the wiki at
http://wiki.enneenne.com/index.php/LinuxPPS_support#How_to_modify_a_refclock_to_work_with_LinuxPPS).

> +	/* Try to find the source */
> +	fd = time_pps_findpath(path, LENPPS, id, LENPPS);
> +	if (fd < 0) {
> +		msyslog(LOG_ERR, "refclock_nmea: cannot find PPS path \"%s\" in the system", path);
> +		return (0);
> +	}
> +	msyslog(LOG_INFO, "refclock_nmea: found PPS source \"%s\" at id #%d on \"%s\"", path, fd, id);
> +#endif	/* PPS_HAVE_FINDPATH */
>  	if (time_pps_create(fd, &up->handle) < 0) {
> -		up->handle = 0;
> +		up->handle_created = 0;
>  		msyslog(LOG_ERR,
>  		    "refclock_nmea: time_pps_create failed: %m");
>  		return (1);
>  	}
> +	up->handle_created = ~0;
>  	return(nmea_ppsapi(peer, 0, 0));
>  #else
>  	return (1);
> @@ -265,8 +299,10 @@
>  	pp = peer->procptr;
>  	up = (struct nmeaunit *)pp->unitptr;
>  #ifdef HAVE_PPSAPI
> -	if (up->handle != 0)
> +	if (up->handle_created) {
>  		time_pps_destroy(up->handle);
> +		up->handle_created = 0;
> +	}
>  #endif /* HAVE_PPSAPI */
>  	io_closeclock(&pp->io);
>  	free(up);
> @@ -374,7 +410,7 @@
>  	/*
>  	 * Convert the timespec nanoseconds field to ntp l_fp units.
>  	 */ 
> -	if (up->handle == 0)
> +	if (!up->handle_created)
>  		return (0);
>  	timeout.tv_sec = 0;
>  	timeout.tv_nsec = 0;

Please, rewiev and test the code and I'll publish it.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
