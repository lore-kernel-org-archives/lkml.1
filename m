Return-Path: <linux-kernel-owner+w=401wt.eu-S1763172AbXHOIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763172AbXHOIOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXHOINW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:13:22 -0400
Received: from ozlabs.org ([203.10.76.45]:58746 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbXHOINS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:13:18 -0400
From: Michael Neuling <mikey@neuling.org>
To: balbir@linux.vnet.ibm.com
cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Documentation: fix getdelays.c example -l option and segv 
In-reply-to: <46C2A505.7040008@linux.vnet.ibm.com> 
References: <18240.1186734285@neuling.org> <46C2A505.7040008@linux.vnet.ibm.com>
Comments: In-reply-to Balbir Singh <balbir@linux.vnet.ibm.com>
   message dated "Wed, 15 Aug 2007 12:32:29 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 15 Aug 2007 18:13:11 +1000
Message-ID: <11201.1187165591@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <46C2A505.7040008@linux.vnet.ibm.com> you wrote:
> Michael Neuling wrote:
> > Fix a couple of minor issues with the getdelays.c example code. 
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> >  Documentation/accounting/getdelays.c |   21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> > 
> > Index: linux-2.6-ozlabs/Documentation/accounting/getdelays.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/Documentation/accounting/getdelays.c
> > +++ linux-2.6-ozlabs/Documentation/accounting/getdelays.c
> > @@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t
> >  	       "IO    %15s%15s\n"
> >  	       "      %15llu%15llu\n"
> >  	       "MEM   %15s%15s\n"
> > -	       "      %15llu%15llu\n"
> > +	       "      %15llu%15llu\n",
> 
> This change looks good!

Looks like it was randomly removed in b663a79c191508f27cd885224b592a878c0ba0f6.

> 
> >  	       "count", "real total", "virtual total", "delay total",
> >  	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
> >  	       t->cpu_delay_total,
> > @@ -335,17 +335,17 @@ int main(int argc, char *argv[])
> >  		}
> >  	}
> > 
> > -	if (tid) {
> > -		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
> > -			      cmd_type, &tid, sizeof(__u32));
> > -		PRINTF("Sent pid/tgid, retval %d\n", rc);
> > -		if (rc < 0) {
> > -			fprintf(stderr, "error sending tid/tgid cmd\n");
> > -			goto done;
> > +	do {
> > +		if (tid) {
> > +			rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
> > +				      cmd_type, &tid, sizeof(__u32));
> > +			PRINTF("Sent pid/tgid, retval %d\n", rc);
> > +			if (rc < 0) {
> > +				fprintf(stderr, "error sending tid/tgid cmd\n")
;
> > +				goto done;
> > +			}
> >  		}
> > -	}
> > 
> > -	do {
> >  		int i;
> > 
> >  		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
> > @@ -430,6 +430,7 @@ int main(int argc, char *argv[])
> >  			}
> >  			na = (struct nlattr *) (GENLMSG_DATA(&msg) + len);
> >  		}
> > +		sleep(2);
> 
> Is this really required? a sleep() in the code. Why do we do multiple
> send_cmd()'s in the do loop? I'll test and get back.

I needed to send another command to receive more data.  Without the per
loop send_cmd, I never got any more stats. 

Should we receive more data without the additional send_cmd?  I've been
running with: 
  ./getdelays -d -p 1 -l

Mikey


