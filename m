Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0BWQZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:25:11 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:24556 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0BWQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:25:09 -0500
Message-ID: <4B840094.10003@oracle.com>
Date: Tue, 23 Feb 2010 08:21:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: [PATCH 1/6] pps: LinuxPPS clients support.
References: <1266928835-5435-1-git-send-email-giometti@linux.it> <1266928835-5435-2-git-send-email-giometti@linux.it>
In-Reply-To: <1266928835-5435-2-git-send-email-giometti@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B8400F0.0141:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/10 04:40, Rodolfo Giometti wrote:
> Each PPS source can be registered/deregistered into the system by
> using special modules called "clients". They simply define the PPS
> sources' attributes and implement the time signal registartion
> mechanism.
> 
> This patch adds a special directory for such clients and adds a dummy
> client that can be useful to test system integrity on real systems.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  drivers/pps/Kconfig          |    2 +
>  drivers/pps/Makefile         |    1 +
>  drivers/pps/clients/Kconfig  |   18 ++++++
>  drivers/pps/clients/Makefile |    9 +++
>  drivers/pps/clients/ktimer.c |  123 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 153 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pps/clients/Kconfig
>  create mode 100644 drivers/pps/clients/Makefile
>  create mode 100644 drivers/pps/clients/ktimer.c


> diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
> new file mode 100644
> index 0000000..60b83be
> --- /dev/null
> +++ b/drivers/pps/clients/Kconfig
> @@ -0,0 +1,18 @@
> +#
> +# PPS clients configuration
> +#
> +
> +if PPS
> +
> +comment "PPS clients support"
> +
> +config PPS_CLIENT_KTIMER
> +	tristate "Kernel timer client (Testing client, use for debug)"
> +	help
> +	  If you say yes here you get support for a PPS debugging client
> +	  which uses a kernel timer to generate the PPS signal.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ktimer.ko.

	  will be called ktimer.

Only a handful of other drivers/kconfigs have that incorrect.

> +
> +endif

> diff --git a/drivers/pps/clients/ktimer.c b/drivers/pps/clients/ktimer.c
> new file mode 100644
> index 0000000..6de5dfc
> --- /dev/null
> +++ b/drivers/pps/clients/ktimer.c
> @@ -0,0 +1,123 @@
> +/*
> + * ktimer.c -- kernel timer test client

> +/*
> + * Global variables
> + */
> +
> +static int source;
> +static struct timer_list ktimer;
> +
> +/*
> + * The kernel timer
> + */
> +
> +static void pps_ktimer_event(unsigned long ptr)
> +{
> +	struct timespec __ts;
> +	struct pps_ktime ts;
> +
> +	/* First of all we get the time stamp... */
> +	getnstimeofday(&__ts);
> +
> +	pr_info("PPS event at %lu\n", jiffies);
> +
> +	/* ... and translate it to PPS time data struct */
> +	ts.sec = __ts.tv_sec;
> +	ts.nsec = __ts.tv_nsec;
> +
> +	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
> +
> +	mod_timer(&ktimer, jiffies + HZ);
> +}
> +
> +/*
> + * The echo function
> + */
> +
> +static void pps_ktimer_echo(int source, int event, void *data)
> +{
> +	pr_info("echo %s %s for source %d\n",
> +		event & PPS_CAPTUREASSERT ? "assert" : "",
> +		event & PPS_CAPTURECLEAR ? "clear" : "",
> +		source);
> +}
> +
> +/*
> + * The PPS info struct
> + */
> +
> +static struct pps_source_info pps_ktimer_info = {
> +	.name		= "ktimer",
> +	.path		= "",
> +	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
> +			  PPS_ECHOASSERT | \
> +			  PPS_CANWAIT | PPS_TSFMT_TSPEC,

We don't usually use \ continuation characters when they are not needed.

> +	.echo 		= pps_ktimer_echo,
> +	.owner		= THIS_MODULE,
> +};


-- 
~Randy
