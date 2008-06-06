Return-Path: <linux-kernel-owner+w=401wt.eu-S1764090AbYFFDrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764090AbYFFDrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYFFDrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:47:46 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:56491 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754970AbYFFDrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:47:45 -0400
Message-ID: <4848B305.9080305@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 09:16:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Scott Wiersdorf <scott@perlcode.org>
CC: Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
References: <20080605194334.GA56830@perlcode.org>
In-Reply-To: <20080605194334.GA56830@perlcode.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wiersdorf wrote:
> This adds a USR1 signal handler to getdelays.c, which causes getdelays
> to close its logfile and reopen it (if '-w logfile' is
> specified). This is useful in situations when getdelays is running for
> a long time (i.e, the log file growing) and you need to rotate the
> logs but don't want to lose any log data.
> 
> Signed-off-by: Scott Wiersdorf <scott@perlcode.org>
> ---
> --- Documentation/accounting/getdelays.c	2008-05-15 09:00:12.000000000 -0600
> +++ Documentation/accounting/getdelays.c	2008-06-05 02:23:57.000000000 -0600
> @@ -50,6 +50,7 @@ int dbg;
>  int print_delays;
>  int print_io_accounting;
>  int print_task_context_switch_counts;
> +volatile sig_atomic_t reopen_log = 0;



>  __u64 stime, utime;
> 
>  #define PRINTF(fmt, arg...) {			\
> @@ -80,6 +81,7 @@ static void usage(void)
>  	fprintf(stderr, "  -l: listen forever\n");
>  	fprintf(stderr, "  -v: debug on\n");
>  	fprintf(stderr, "  -C: container path\n");
> +	fprintf(stderr, "\nSend USR1 to reopen the logfile if -w is used.\n");

Please mention that old data will be lost and that SIGUSR1 will take affect
after some data is received.

>  }
> 
>  /*
> @@ -231,6 +233,30 @@ void print_ioacct(struct taskstats *t)
>  		(unsigned long long)t->cancelled_write_bytes);
>  }
> 
> +void catch_usr1(int sig)
> +{
> +	reopen_log = 1;
> +	signal(sig, catch_usr1);
> +}
> +

Aren't we better of using the newer sigaction primitives? IIRC, signal can be
racy. The man page states "Avoid its use"

> +int reopen_logfile(int fd, char *logfile)
> +{
> +	if (fd) {
> +		PRINTF("USR1 received. Closing logfile.\n");
> +		close(fd);

So sending USR1 causes data to be lost?

> +	}
> +	fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
> +		  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
> +	if (fd == -1) {
> +		perror("Cannot open output file\n");
> +		exit(1);
> +	}
> +
> +	reopen_log = 0;
> +
> +	return fd;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int c, rc, rep_len, aggr_len, len2, cmd_type;
> @@ -320,12 +346,8 @@ int main(int argc, char *argv[])
>  	}
> 
>  	if (write_file) {
> -		fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
> -			  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
> -		if (fd == -1) {
> -			perror("Cannot open output file\n");
> -			exit(1);
> -		}
> +		fd = reopen_logfile(fd, logfile);
> +		signal(SIGUSR1, catch_usr1); /* only set when write_file is set */
>  	}
> 
>  	if ((nl_sd = create_nl_socket(NETLINK_GENERIC)) < 0)
> @@ -444,6 +466,9 @@ int main(int argc, char *argv[])
>  								err(1,"write error\n");
>  							}
>  						}
> +						if (reopen_log) {
> +							fd = reopen_logfile(fd, logfile);
> +						}

This seems way of the 80 character space. You have braces that are not required.

>  						if (!loop)
>  							goto done;
>  						break;
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
