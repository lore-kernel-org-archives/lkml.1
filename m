Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZIXNrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZIXNrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIXNrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:47:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:34235 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZIXNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:47:16 -0400
Message-ID: <4ABB7855.4080409@gmail.com>
Date: Thu, 24 Sep 2009 15:47:01 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [patch] perf timechart: Add a power-only mode
References: <20090924154013.0675ab71@infradead.org>
In-Reply-To: <20090924154013.0675ab71@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 24 Sep 2009 15:47:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: perf timechart: Add a power-only mode
> 
> For doing work on the Linux power management components,
> I need to make long (30+ seconds) traces. Currently,
> this then results in a HUGE svg file, with mostly
> process data that isn't interesting.
> 
> This patch adds a --power-only mode to perf timechart
> that only outputs the CPU power section of the SVG;
> this significantly reduces the size of the SVG file,
> making even 30+ second traces viewable with inkscape.
> 
> As a minor tweak for the same effect, the minimum text
> size is decreased; current inkscape cannot zoom in
> deep enough to show text this small, but it reduces
> inkscape compute time.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index 1c2ed30..a791009 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -31,6 +31,9 @@ OPTIONS
>  -w::
>  --width=::
>          Select the width of the SVG file (default: 1000)
> +-p::
> +--power-only::
> +        Only output the CPU power section of the diagram
>  
>  
>  SEE ALSO
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index 4405681..702d8fe 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -46,6 +46,8 @@ static u64		turbo_frequency;
>  
>  static u64		first_time, last_time;
>  
> +static int		power_only;
> +
>  
>  static struct perf_header	*header;
>  
> @@ -547,7 +549,7 @@ static void end_sample_processing(void)
>  	u64 cpu;
>  	struct power_event *pwr;
>  
> -	for (cpu = 0; cpu < numcpus; cpu++) {
> +	for (cpu = 0; cpu <= numcpus; cpu++) {

hmm, why test is now "cpu <= numcpus" ?

>  		pwr = malloc(sizeof(struct power_event));
>  		if (!pwr)
>  			return;
> @@ -871,7 +873,7 @@ static int determine_display_tasks(u64 threshold)
>  		/* no exit marker, task kept running to the end */
>  		if (p->end_time == 0)
>  			p->end_time = last_time;
> -		if (p->total_time >= threshold)
> +		if (p->total_time >= threshold && !power_only)
>  			p->display = 1;
>  
>  		c = p->all;
> @@ -882,7 +884,7 @@ static int determine_display_tasks(u64 threshold)
>  			if (c->start_time == 1)
>  				c->start_time = first_time;
>  
> -			if (c->total_time >= threshold) {
> +			if (c->total_time >= threshold && !power_only) {
>  				c->display = 1;
>  				count++;
>  			}
> @@ -1134,6 +1136,8 @@ static const struct option options[] = {
>  		    "output file name"),
>  	OPT_INTEGER('w', "width", &svg_page_width,
>  		    "page width"),
> +	OPT_BOOLEAN('p', "power-only", &power_only,
> +		    "output power data only"),
>  	OPT_END()
>  };
>  
> diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
> index a778fd0..856655d 100644
> --- a/tools/perf/util/svghelper.c
> +++ b/tools/perf/util/svghelper.c
> @@ -28,7 +28,7 @@ static u64 turbo_frequency, max_freq;
>  
>  int svg_page_width = 1000;
>  
> -#define MIN_TEXT_SIZE 0.001
> +#define MIN_TEXT_SIZE 0.01
>  
>  static u64 total_height;
>  static FILE *svgfile;
> @@ -217,6 +217,18 @@ static char *cpu_model(void)
>  		}
>  		fclose(file);
>  	}
> +
> +	/* CPU type */
> +	file = fopen("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", "r");

if this cpu is offline

 /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies: No such file or directory


> +	if (file) {
> +		while (fgets(buf, 255, file)) {
> +			unsigned int freq;
> +			freq = strtoull(buf, NULL, 10);
> +			if (freq > max_freq)
> +				max_freq = freq;
> +		}
> +		fclose(file);
> +	}
>  	return cpu_m;
>  }
>  
> 
> 

