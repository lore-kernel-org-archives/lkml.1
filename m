Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZGVHud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZGVHud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZGVHud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:50:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62242 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbZGVHuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:50:32 -0400
Message-ID: <4A66C468.5070100@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 15:48:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: Add module tracepoints
References: <4A6582C1.2040609@cn.fujitsu.com> <200907221352.17850.rusty@rustcorp.com.au>
In-Reply-To: <200907221352.17850.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 21 Jul 2009 06:26:33 pm Li Zefan wrote:
>> Add trace points to trace module_load, module_free, module_get,
>> module_put and module_request, and use trace_event facility
>> to get the trace output.
> 
> Hi Li Zefan,
> 
>    I don't know anything about tracing, but the module code changes look
> simple and fine to me.
> 

I guess I can take this as an ack. :)

Tracing is used to have a deep insight into the system, analyse
performance issue, help debugging, dump info at system panic,
etc..

And those module trace events also can be used with other trace
events and tracers, an example below:

# mount -t debugfs xxx /mnt
# cd /mnt/tracing
# echo module > set_event
# echo scsi_device_get > set_graph_function
# echo scsi_device_put >> set_graph_function
# mount /dev/sda1 /media
# cat trace
# tracer: function_graph                         
#                                                
# CPU  DURATION                  FUNCTION CALLS  
# |     |   |                     |   |   |   |
 0)               |  scsi_device_get() {
 0)   1.215 us    |    get_device();
 0)               |    ftrace_raw_event_module_get() {
 0)   0.870 us    |      strlen();
 0)               |      /* module_get: sata_sis call_site=scsi_device_get refcnt=9 */
 0)   1.003 us    |      strcpy();
 0)   5.821 us    |    }
 0) + 17.304 us   |  }
 1)               |  scsi_device_put() {
 1)   1.807 us    |    module_refcount();
 1)               |    module_put() {
 1)               |      ftrace_raw_event_module_put() {
 1)   0.748 us    |        strlen();
 1)               |        /* module_put: sata_sis call_site=return_to_handler refcnt=-6 */
 1)   0.856 us    |        strcpy();
 1)   4.799 us    |      }
 1)   6.799 us    |    }
 1)   0.771 us    |    put_device();
 1) + 17.464 us   |  }
 ------------------------------------------
 1)   mount-2452   =>  mount.n-2453
 ------------------------------------------


