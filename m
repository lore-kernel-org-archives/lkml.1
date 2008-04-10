Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYDJN5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYDJN5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYDJN5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:57:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51292 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753032AbYDJN5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:57:44 -0400
Date: Thu, 10 Apr 2008 08:57:40 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, bert.wesarg@googlemail.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo
 v3
Message-Id: <20080410085740.a7e08672.pj@sgi.com>
In-Reply-To: <20080408184301.842103000@polaris-admin.engr.sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184301.842103000@polaris-admin.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
+		n = type?
+			cpulist_scnprintf(buf, len-2, *mask):
+			cpumask_scnprintf(buf, len-2, *mask);

I suspect most of us would find the following variant easier to read:

		if (type)
			n = cpulist_scnprintf(buf, len - 2, *mask);
		else
			n = cpumask_scnprintf(buf, len - 2, *mask);


Then, going further, the rather too vague "type" parameter name,
without comment and taking just bare constant values 0 or 1, seems
more opaque than necessary.

I can imagine this being easier to read as something like:


typedef enum { print_as_mask, print_as_list } map_printer_t;

static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
				       map_printer_t mpt, char *buf)
{
       ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
       int n = 0;

       if (len > 1) {
		cpumask_t *mask = &this_leaf->shared_cpu_map;

		if (mpt == print_as_mask)
			n = cpumask_scnprintf(buf, len - 2, *mask);
		else
			n = cpulist_scnprintf(buf, len - 2, *mask);
		buf[n++] = '\n';
		buf[n] = '\0';
       }
       return n;
}

static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf)
{
       return show_shared_cpu_map_func(leaf, print_as_mask, buf);
}

static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf)
{
       return show_shared_cpu_map_func(leaf, print_as_list, buf);
}



-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
