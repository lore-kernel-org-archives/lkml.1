Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZI1TGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZI1TGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZI1TGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:06:06 -0400
Received: from mail201.messagelabs.com ([216.82.254.211]:8942 "EHLO
	mail201.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZI1TGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:06:04 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott.Kilau@digi.com
X-Msg-Ref: server-6.tower-201.messagelabs.com!1254164768!18444149!1
X-StarScan-Version: 6.1.3; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: "Kilau, Scott" <Scott.Kilau@digi.com>
To: "'Breno Leitao'" <leitao@linux.vnet.ibm.com>,
       "'Wen Xiong'" <wenxiong@us.ibm.com>
CC: "'alan@lxorguk.ukuu.org.uk'" <alan@lxorguk.ukuu.org.uk>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Sep 2009 14:06:06 -0500
Subject: RE: Adding EEH handlers
Thread-Topic: Adding EEH handlers
Thread-Index: Acoy9ZNoeMvaOtOvSdexuicGMfboYQNePn9Q
Message-ID: <A961E3870077E34C8FEF355D71BFDEAAC6AF0231AB@mtk-sms-exch01.digi.com>
References: <4AAA6E5E.9000900@linux.vnet.ibm.com>
In-Reply-To: <4AAA6E5E.9000900@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8SJ6Q16014785

> -----Original Message-----
> From: Breno Leitao [mailto:leitao@linux.vnet.ibm.com]
> Sent: Friday, September 11, 2009 10:36 AM
> To: Wen Xiong; Kilau, Scott
> Cc: alan@lxorguk.ukuu.org.uk; Linux Kernel Mailing List
> Subject: jsm: Adding EEH handlers
> 
> Adding EEH handlers for the serial jsm driver. This patch adds
> the PCI error handlers and also register them to be called when
> a error is detected.
> 
> Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
> ---
> diff --git a/drivers/serial/jsm/jsm_driver.c
> b/drivers/serial/jsm/jsm_driver.c
> index b3604aa..b37d2e2 100644
> --- a/drivers/serial/jsm/jsm_driver.c
> +++ b/drivers/serial/jsm/jsm_driver.c
> @@ -48,6 +48,20 @@ struct uart_driver jsm_uart_driver = {
>  	.nr		= NR_PORTS,
>  };
> 
> +static pci_ers_result_t jsm_io_error_detected(struct pci_dev *pdev,
> +					pci_channel_state_t state);
> +static pci_ers_result_t jsm_io_slot_reset(struct pci_dev *pdev);
> +static void jsm_io_resume(struct pci_dev *pdev);
> +
> +static struct pci_error_handlers jsm_err_handler = {
> +	.error_detected = jsm_io_error_detected,
> +	.slot_reset = jsm_io_slot_reset,
> +	.resume = jsm_io_resume,
> +};
> +
>  int jsm_debug;
>  module_param(jsm_debug, int, 0);
>  MODULE_PARM_DESC(jsm_debug, "Driver debugging level");
> @@ -164,6 +178,7 @@ static int __devinit jsm_probe_one(struct pci_dev
> *pdev, const struct pci_device
>  	}
> 
>  	pci_set_drvdata(pdev, brd);
> +	pci_save_state(pdev);
> 
>  	return 0;
>   out_free_irq:
> @@ -222,8 +237,39 @@ static struct pci_driver jsm_driver = {
>  	.id_table	= jsm_pci_tbl,
>  	.probe		= jsm_probe_one,
>  	.remove		= __devexit_p(jsm_remove_one),
> +	.err_handler	= &jsm_err_handler,
>  };
> 
> +static pci_ers_result_t jsm_io_error_detected(struct pci_dev *pdev,
> +					pci_channel_state_t state)
> +{
> +	struct jsm_board *brd = pci_get_drvdata(pdev);
> +
> +	jsm_remove_uart_port(brd);
> +
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +static pci_ers_result_t jsm_io_slot_reset(struct pci_dev *pdev)
> +{
> +	pci_enable_device(pdev);
> +	pci_set_master(pdev);
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
> +static void jsm_io_resume(struct pci_dev *pdev)
> +{
> +	struct jsm_board *brd = pci_get_drvdata(pdev);
> +
> +	pci_restore_state(pdev);
> +
> +	jsm_uart_port_init(brd);
> +}
> +
>  static int __init jsm_init_module(void)
>  {
>  	int rc;
> diff --git a/drivers/serial/jsm/jsm_tty.c
> b/drivers/serial/jsm/jsm_tty.c
> index 00f4577..e70f2c1 100644
> --- a/drivers/serial/jsm/jsm_tty.c
> +++ b/drivers/serial/jsm/jsm_tty.c
> @@ -432,7 +432,7 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
>  	return 0;
>  }
> 
> -int __devinit jsm_uart_port_init(struct jsm_board *brd)
> +int jsm_uart_port_init(struct jsm_board *brd)
>  {
>  	int i;
>  	unsigned int line;


Looks good, thanks Breno!
Acked-by: Scott Kilau <scottk@digi.com>



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
