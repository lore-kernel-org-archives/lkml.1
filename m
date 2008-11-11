Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYKKMQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYKKMQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYKKMQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:16:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbYKKMQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:16:35 -0500
Date: Tue, 11 Nov 2008 13:16:07 +0100
From: Holger Macht <hmacht@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [patch 20/23] ACPI: dock: avoid check _STA method
Message-ID: <20081111121607.GA32066@homac.suse.de>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org,
	Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
References: <20081107224818.593212310@mini.kroah.org> <20081107231606.GU1108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107231606.GU1108@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07. Nov - 15:16:06, Greg KH wrote:
> 2.6.26-stable review patch.  If anyone has any objections, please let us know.

Objecting. This will only work in conjunction with

  commit 39a0ad871000d2a016a4fa113a6e53d22aabf25d
  Author: Zhao Yakui <yakui.zhao@intel.com>
  Date:   Mon Aug 11 13:40:22 2008 +0800

      ACPI : Load device driver according to the status of acpi device

Otherwise a device struct already exists although the device is not
present.

Regards,
	Holger

> 
> ------------------
> 
> From: Shaohua Li <shaohua.li@intel.com>
> 
> commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db upstream.
> 
> ACPI: dock: avoid check _STA method
> 
> In some BIOSes, every _STA method call will send a notification again,
> this cause freeze. And in some BIOSes, it appears _STA should be called
> after _DCK. This tries to avoid calls _STA, and still keep the device
> present check.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10431
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/acpi/dock.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -599,14 +599,17 @@ static int handle_eject_request(struct d
>  static void dock_notify(acpi_handle handle, u32 event, void *data)
>  {
>  	struct dock_station *ds = data;
> +	struct acpi_device *tmp;
>  
>  	switch (event) {
>  	case ACPI_NOTIFY_BUS_CHECK:
> -		if (!dock_in_progress(ds) && dock_present(ds)) {
> +		if (!dock_in_progress(ds) && acpi_bus_get_device(ds->handle,
> +		   &tmp)) {
>  			begin_dock(ds);
>  			dock(ds);
>  			if (!dock_present(ds)) {
>  				printk(KERN_ERR PREFIX "Unable to dock!\n");
> +				complete_dock(ds);
>  				break;
>  			}
>  			atomic_notifier_call_chain(&dock_notifier_list,
> 
