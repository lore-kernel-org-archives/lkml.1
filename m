Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYKDPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYKDPon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYKDPof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:44:35 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:40777 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYKDPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=MQY340a4Rp1qrjBinwVqqgWqQz5nxOp/ua8ADbl8DVB5yaFDr8WpLVDBng/FTKQoQJ
         xRYdsiH9NEyVOsWFQ95WJ8saEyUEemBN0yUY23xi8j1xFUrGYjpJrfnJw2lgMMNaC5ap
         ivGFUNdz68sSGiBGSdSL1m1Z5Yp+860WQq+n0=
Message-ID: <49106DD7.9010307@tuffmail.co.uk>
Date: Tue, 04 Nov 2008 15:44:23 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
References: <bspwK-420-11@gated-at.bofh.it> <bujnh-2fr-5@gated-at.bofh.it> <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org>
In-Reply-To: <20081104151128.GA22544@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Nov 04, 2008 at 03:01:07PM +0000, Alan Jenkins wrote:
>
>   
>> Hey... you're making this conditional on whether a power led is reported
>> present, right?  Are you sure the EeePC doesn't report itself as having
>> a power led?
>>     
>
> Doesn't seem to on the one I was testing, but it's possible. Any chance 
> you could instrument it? There's only a few calls to msleep in 
> pcihp_ctrl.c.
>   

And pciehp_hpc.c!

I instrumented all the delays I could find. hpc_check_lnk_status() was
the only one that came up.  1000ms delay per call, and I get 6 such delays.

The code is saying my hardware lacks "Data Layer Link Active Reporting".



    static int hpc_check_lnk_status(struct controller *ctrl)
    {
        u16 lnk_status;
        int retval = 0;

            /*
             * Data Link Layer Link Active Reporting must be capable for
             * hot-plug capable downstream port. But old controller might
             * not implement it. In this case, we wait for 1000 ms.
             */
            if (ctrl->link_active_reporting){
                    /* Wait for Data Link Layer Link Active bit to be set */
                    pcie_wait_link_active(ctrl);
                    /*
                     * We must wait for 100 ms after the Data Link Layer
                     * Link Active bit reads 1b before initiating a
                     * configuration access to the hot added device.
                     */
                    msleep(100);
            } else {
                    msleep(1000);

