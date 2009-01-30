Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZA3WG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZA3WG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZA3WGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:06:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757275AbZA3WGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:06:02 -0500
Date: Fri, 30 Jan 2009 14:05:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: gerickson@nuovations.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] edac: new ppc4xx driver module
Message-Id: <20090130140520.ca1b2b8e.akpm@linux-foundation.org>
In-Reply-To: <498330d2.qJmeNSKw5V89V22/%dougthompson@xmission.com>
References: <498330d2.qJmeNSKw5V89V22/%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 09:54:42 -0700
dougthompson@xmission.com wrote:

> From: Grant Erickson <gerickson@nuovations.com>

Perhaps a powerpc mailing list should have been cc'ed?

> This adds support for an EDAC memory controller adaptation driver for
> the "ibm,sdram-4xx-ddr2" ECC controller realized in the AMCC PowerPC
> 405EX[r].
> 
> At present, this driver has been developed and tested against the
> controller realization in the AMCC PPC405EX[r] on the AMCC Kilauea and
> Haleakala boards (256 MiB w/o ECC memory soldered onto the board) and
> a proprietary board based on those designs (128 MiB ECC memory, also
> soldered onto the board).
> 
> In the future, dynamic feature detection and handling needs to be
> added for the other realizations of this controller found in the
> 440SP, 440SPe, 460EX, 460GT and 460SX.
> 
> Eventually, this driver will likely be evolved and adapted to the
> above variant realizations of this controller as well as broken apart
> to handle the other known ECC-capable controllers prevalent in other
> PPC4xx processors:
> 
>   - IBM SDRAM (405GP, 405CR and 405EP) "ibm,sdram-4xx"
>   - IBM DDR1 (440GP, 440GX, 440EP and 440GR) "ibm,sdram-4xx-ddr"
>   - Denali DDR1/DDR2 (440EPX and 440GRX) "denali,sdram-4xx-ddr2"
> 
> Patch v2 removes the 'type' field from the of_device_id match
> structure to reflect the corresponding removal of the 'device_type'
> field from the device tree node.
> 
> Patch v3 incorporates feedback from Josh Boyer regarding compliance of
> switch statements with Linux coding style, removing gratuitous printk
> wrappers, and using the DCR mapping from the device tree rather than
> using a fixed mapping.
> 
> Patch v4 resync's the patch against the top-of-tree as 'git apply' was
> reporting "fatal: new file drivers/edac/ppc4xx_edac.h depends on old
> contents".
> 
>
> ...
>
> +/**
> + * This routine writes the provided data to the controller's specified
> + * indirect DCR register.
> + *
> + * @param dcr_host A pointer to the DCR mapping.
> + * @param idcr_n The indirect DCR register to write.
> + * @param value The data to write.
> + */

These comments try really hard to be in kerneldoc form, but don't quite
succeed.

The first line should be of the form

 * mtsdram - write the provided data to the controller's specified indirect DCR register.

(note that it has to all be on a single line, too).

>
> ...
>
> +/**
> + * This routine generates to the provided buffer the portion of the
> + * driver-unique report message associated with the ECCESS[BKNER]
> + * field of the specified ECC status.
> + *
> + * @param mci A pointer to the EDAC memory controller instance
> + * associated with the bank message being generated.
> + * @param status A pointer to the ECC status structure to generate the
> + * message from.
> + * @param buffer A pointer to the buffer in which to generate the
> + * message.
> + * @param size The size, in bytes, of space available in buffer.
> + *
> + * @return The number of characters generated on success; otherwise, <
> + * 0 on error.

And I don't think that kerneldoc understands `@return'?  It should :(


> + */
> +static int
> +ppc4xx_edac_generate_bank_message(const struct mem_ctl_info *mci,
> +				  const struct ppc4xx_ecc_status *status,
> +				  char *buffer,
> +				  size_t size)
> +{
> +	int n, total = 0;
> +	size_t row, rows;

It seems strange to use a size_t here.

> +	n = snprintf(buffer, size, "%s: Banks: ", mci->dev_name);
> +
> +	if (n < 0 || n >= size)
> +		goto fail;
> +
> +	buffer += n;
> +	size -= n;
> +	total += n;
> +
> +	for (rows = 0, row = 0; row < mci->nr_csrows; row++)
> +		if (ppc4xx_edac_check_bank_error(status, row)) {
> +				n = snprintf(buffer, size,
> +					 "%s%d",
> +					 (rows++ ? ", " : ""), row);

You can't print a size_t with %d.  It should use %z.

> +			if (n < 0 || n >= size)
> +				goto fail;
> +
> +			buffer += n;
> +			size -= n;
> +			total += n;
> +		}
> +
> +	n = snprintf(buffer, size, "%s; ", rows ? "" : "None");
> +
> +	if (n < 0 || n >= size)
> +		goto fail;
> +
> +	buffer += n;
> +	size -= n;
> +	total += n;
> +
> + fail:
> +	return total;
> +}
> +
>
> ...
>
> +static int
> +ppc4xx_edac_generate_lane_message(const struct mem_ctl_info *mci,
> +				  const struct ppc4xx_ecc_status *status,
> +				  char *buffer,
> +				  size_t size)
> +{
> +	int n, total = 0;
> +	size_t lane, lanes;
> +	const unsigned int first_lane = 0;
> +	const unsigned int lane_count = 16;
> +
> +	n = snprintf(buffer, size, "; Byte Lane Errors: ");
> +
> +	if (n < 0 || n >= size)
> +		goto fail;
> +
> +	buffer += n;
> +	size -= n;
> +	total += n;
> +
> +	for (lanes = 0, lane = first_lane; lane < lane_count; lane++) {
> +		if ((status->ecces & SDRAM_ECCES_BNCE_ENCODE(lane)) != 0) {
> +			n = snprintf(buffer, size,
> +				     "%s%d",
> +				     (lanes++ ? ", " : ""), lane);

Various dittoes.

> +			if (n < 0 || n >= size)
> +				goto fail;
> +
> +			buffer += n;
> +			size -= n;
> +			total += n;
> +		}
> +	}
> +
> +	n = snprintf(buffer, size, "%s; ", lanes ? "" : "None");
> +
> +	if (n < 0 || n >= size)
> +		goto fail;
> +
> +	buffer += n;
> +	size -= n;
> +	total += n;
> +
> + fail:
> +	return total;
> +}
> +
>
> ...
>
> +static int
> +ppc4xx_edac_generate_plb_message(const struct mem_ctl_info *mci,
> +				 const struct ppc4xx_ecc_status *status,
> +				 char *buffer,
> +				 size_t size)
> +{
> +	unsigned int master;
> +	bool read;
> +
> +	if ((status->besr & SDRAM_BESR_MASK) == 0)
> +		return 0;
> +
> +	if ((status->besr & SDRAM_BESR_M0ET_MASK) == SDRAM_BESR_M0ET_NONE)
> +		return 0;
> +
> +	read = ((status->besr & SDRAM_BESR_M0RW_MASK) == SDRAM_BESR_M0RW_READ);
> +
> +	master = SDRAM_BESR_M0ID_DECODE(status->besr);
> +
> +	return snprintf(buffer, size,
> +			"%s error w/ PLB master %u \"%s\"; ",

more

> +			(read ? "Read" : "Write"),
> +			master,
> +			(((master >= SDRAM_PLB_M0ID_FIRST) &&
> +			  (master <= SDRAM_PLB_M0ID_LAST)) ?
> +			 ppc4xx_plb_masters[master] : "UNKNOWN"));
> +}
> +
>
> ...
>
> +/**
> + * This routine handles an ibm,sdram-4xx-ddr2 controller ECC
> + * correctable error. Per the aforementioned discussion, there's not
> + * enough status available to use the full EDAC correctable error
> + * interface, so we just pass driver-unique message to the "no info"
> + * interface.
> + *
> + * @param mci A pointer to the EDAC memory controller instance
> + * associated with the correctable error being handled and reported.
> + * @param status A pointer to the ECC status structure associated with
> + * the correctable error being handled and reported.
> + */
> +static void
> +ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
> +		      const struct ppc4xx_ecc_status *status)
> +{
> +	int row;
> +	char message[PPC4XX_EDAC_MESSAGE_SIZE];

256 bytes on the stack is getting a bit large.

> +	ppc4xx_edac_generate_message(mci, status, message, sizeof(message));
> +
> +	for (row = 0; row < mci->nr_csrows; row++)
> +		if (ppc4xx_edac_check_bank_error(status, row))
> +			edac_mc_handle_ce_no_info(mci, message);
> +}
> +
> +/**
> + * This routine handles an ibm,sdram-4xx-ddr2 controller ECC
> + * uncorrectable error.
> + *
> + * @param mci A pointer to the EDAC memory controller instance
> + * associated with the uncorrectable error being handled and reported.
> + * @param status A pointer to the ECC status structure associated with
> + * the uncorrectable error being handled and reported.
> + */
> +static void
> +ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
> +		      const struct ppc4xx_ecc_status *status)
> +{
> +	const u64 bear = ((u64)status->bearh << 32 | status->bearl);
> +	const unsigned long pfn = bear >> PAGE_SHIFT;

The term `pfn' has a specific meaining in-kernel, and I have a
suspicion that this variable doesn't match it.

> +	const unsigned long poff = bear & ~PAGE_MASK;
> +	int row;
> +	char message[PPC4XX_EDAC_MESSAGE_SIZE];

stack..

> +	ppc4xx_edac_generate_message(mci, status, message, sizeof(message));
> +
> +	for (row = 0; row < mci->nr_csrows; row++)
> +		if (ppc4xx_edac_check_bank_error(status, row))
> +			edac_mc_handle_ue(mci, pfn, poff, row, message);
> +}
> +
>
> ...
>
> +/**
> + * This routine implements the interrupt handler for both correctable
> + * and uncorrectable ECC errors for the ibm,sdram-4xx-ddr2
> + * controller. It simply calls through to the same routine used during
> + * polling to check, report and clear the ECC status.
> + *
> + * @param irq The virtual interrupt number being serviced.
> + * @param dev_id A pointer to the EDAC memory controller instance
> + * associated with the interrupt being handled.
> + *
> + * @return
> + */
> +static irqreturn_t
> +ppc4xx_edac_isr(int irq, void *dev_id)
> +{
> +	struct mem_ctl_info *mci = (struct mem_ctl_info *)dev_id;

unneeded and undesirable cast of void*.

> +	ppc4xx_edac_check(mci);
> +
> +	return IRQ_HANDLED;
> +}
> +
>
> ...
>
> +static int __devinit
> +ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
> +		    struct of_device *op,
> +		    const struct of_device_id *match,
> +		    const dcr_host_t *dcr_host,
> +		    u32 mcopt1)
> +{
> +	int status = 0;
> +	const u32 memcheck = (mcopt1 & SDRAM_MCOPT1_MCHK_MASK);
> +	struct ppc4xx_edac_pdata *pdata = NULL;
> +	const struct device_node *np = op->node;
> +
> +	if (mci == NULL || op == NULL || match == NULL || dcr_host == NULL)
> +		return -EINVAL;

Can all of these really happen?

> +	/* Initial driver pointers and private data */
> +
> +	mci->dev		= &op->dev;
> +
> +	dev_set_drvdata(mci->dev, mci);
> +
> +	pdata			= mci->pvt_info;
> +
> +	pdata->dcr_host		= *dcr_host;
> +	pdata->irqs.sec		= NO_IRQ;
> +	pdata->irqs.ded		= NO_IRQ;
> +
> +	/* Initialize controller capabilities and configuration */
> +
> +	mci->mtype_cap		= (MEM_FLAG_DDR | MEM_FLAG_RDDR |
> +				   MEM_FLAG_DDR2 | MEM_FLAG_RDDR2);
> +
> +	mci->edac_ctl_cap	= (EDAC_FLAG_NONE |
> +				   EDAC_FLAG_EC |
> +				   EDAC_FLAG_SECDED);
> +
> +	mci->scrub_cap		= SCRUB_NONE;
> +	mci->scrub_mode		= SCRUB_NONE;
> +
>
> ...
>

