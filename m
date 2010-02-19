Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0BSVyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:54:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:60190 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab0BSVyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:54:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,505,1262592000"; 
   d="scan'208";a="493962678"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Matthew Garrett <mjg@redhat.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Feb 2010 13:53:04 -0800
Subject: RE: [E1000-devel] [PATCH v3 2/2] e1000e: Don't disable jumbo frames
 on	82573L due to eeprom contents
Thread-Topic: [E1000-devel] [PATCH v3 2/2] e1000e: Don't disable jumbo
 frames on	82573L due to eeprom contents
Thread-Index: AcqrRja7UXUHXLziTMelmodrzi5ttQGZqs2w
Message-ID: <8DD2590731AB5D4C9DBF71A877482A9061394283@orsmsx509.amr.corp.intel.com>
References: <1265912094-4705-1-git-send-email-mjg@redhat.com>
 <1265912094-4705-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1265912094-4705-2-git-send-email-mjg@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 11, 2010 10:15 AM, Matthew Garrett wrote:
> According to the 82573L errata, jumbo frames will work correctly if
> ASPM 
> is disabled. Since we disable ASPM on these devices, leave jumbo
> frames 
> enabled.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
> Updated to provide the right chip name
> 
>  drivers/net/e1000e/82571.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
> index 02d67d0..f26edf7 100644
> --- a/drivers/net/e1000e/82571.c
> +++ b/drivers/net/e1000e/82571.c
> @@ -330,7 +330,6 @@ static s32 e1000_get_variants_82571(struct
>  	e1000_adapter *adapter) struct e1000_hw *hw = &adapter->hw;
>  	static int global_quad_port_a; /* global port a indication */
>  	struct pci_dev *pdev = adapter->pdev;
> -	u16 eeprom_data = 0;
>  	int is_port_b = er32(STATUS) & E1000_STATUS_FUNC_1;
>  	s32 rc;
> 
> @@ -381,16 +380,10 @@ static s32 e1000_get_variants_82571(struct
>  		e1000_adapter *adapter) if (pdev->device ==
>  			E1000_DEV_ID_82571EB_SERDES_QUAD) adapter->flags &= ~FLAG_HAS_WOL;
>  		break;
> -
>  	case e1000_82573:
>  		if (pdev->device == E1000_DEV_ID_82573L) {
> -			if (e1000_read_nvm(&adapter->hw, NVM_INIT_3GIO_3, 1,
> -				       &eeprom_data) < 0)
> -				break;
> -			if (!(eeprom_data & NVM_WORD1A_ASPM_MASK)) {
> -				adapter->flags |= FLAG_HAS_JUMBO_FRAMES;
> -				adapter->max_hw_frame_size = DEFAULT_JUMBO;
> -			}
> +			adapter->flags |= FLAG_HAS_JUMBO_FRAMES;
> +			adapter->max_hw_frame_size = DEFAULT_JUMBO;
>  		}
>  		break;
>  	default:

Actually, the driver only disables L1 ASPM, it does not disable L0s ASPM.  The erratum is unclear whether jumbo frames are not supported in L0s, L1 or both modes (the code suggests both modes must be disabled).  I will look into this further.

Thanks,
Bruce.