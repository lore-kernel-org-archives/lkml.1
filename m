Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbXENVOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbXENVOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXENVOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:14:30 -0400
Received: from zakalwe.fi ([80.83.5.154]:46212 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXENVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:14:29 -0400
Date: Tue, 15 May 2007 00:13:38 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH] ALSA sound driver for SEGA Dreamcast AICA (pcm)
Message-ID: <20070514211338.GC10873@zakalwe.fi>
References: <92a12cdb0705141331w54b80209n4f929e8d4331013@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <92a12cdb0705141331w54b80209n4f929e8d4331013@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 09:32:00PM +0100, Adrian McMenamin wrote:
> +MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
> +MODULE_DESCRIPTION("Dreamcast AICA sound (pcm) driver");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("{{Yamaha/SEGA, AICA}}");
> +
> +/* module parameters */
> +#define CARD_NAME "AICA"
> +static int index = -1;
> +static char *id;
> +static int enable = 1;
> +module_param(index, int, 0444);
> +MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
> +module_param(id, charp, 0444);
> +MODULE_PARM_DESC(id, "ID string for " CARD_NAME " soundcard.");
> +module_param(enable, bool, 0644);
> +MODULE_PARM_DESC(enable, "Enable " CARD_NAME " soundcard.");
> +
> +/* Use workqueue */
> +
> +static struct spu_work_holder {
> +	struct work_struct spu_dma_work;
> +	void *sspointer;
> +} spu_working;
> +
> +static struct workqueue_struct *aica_queue;
> +
> +/* Simple platform device */
> +static struct platform_device *pd;
> +static struct resource aica_memory_space[2] = {
> +	{
> +	 .name = "AICA ARM CONTROL",
> +	 .start = ARM_RESET_REGISTER,
> +	 .flags = IORESOURCE_MEM,
> +	 .end = ARM_RESET_REGISTER + 3,
> +	 },
> +	{
> +	 .name = "AICA Sound RAM",
> +	 .start = SPU_MEMORY_BASE,
> +	 .flags = IORESOURCE_MEM,
> +	 .end = SPU_MEMORY_BASE + 0x200000 - 1,
> +	 },
> +};
> +
> +/* SPU specific functions */
> +/* spu_write_wait - wait for G2-SH FIFO to clear */
> +static inline void spu_write_wait(void)
> +{
> +	int time_count;
> +	time_count = 0;
> +	while (1) {
> +		if (!(readl(G2_FIFO) & 0x11))
> +			break;
> +		/* To ensure hardware failure doesn't wedge kernel */
> +		time_count++;
> +		if (time_count > 0x10000)
> +			break;
> +	}
> +}
> +
> +/* spu_memset - write to memory in SPU address space */
> +static void spu_memset(uint32_t toi, uint32_t what, int length)

That is against coding style. Use u32, s32 instead of C99 types. 
Same for u8/s8.

> +/* spu_memload - write to SPU address space */
> +static void spu_memload(uint32_t toi, void __iomem * from, int length)
> +{
> +	uint32_t __iomem *froml = from;
> +	uint32_t __iomem *to = (uint32_t __iomem *) (SPU_MEMORY_BASE + toi);
> +	int i, val;
> +	if (length % 4)
> +		length = (length / 4) + 1;
> +	else
> +		length = length / 4;

Use: length = DIV_ROUND_UP(length, 4).

> +	spu_write_wait();
> +	for (i = 0; i < length; i++) {
> +		val = *froml;
> +		writel(val, to);
> +		froml++;
> +		to++;
> +		if (i && !(i % 8))
> +			spu_write_wait();
> +	}
> +}
> +
> +/* spu_disable - set spu registers to stop sound output */
> +static void spu_disable(void)
> +{
> +	int i;
> +	uint32_t regval;
> +	spu_write_wait();
> +	regval = readl(ARM_RESET_REGISTER);
> +	regval |= 1;
> +	spu_write_wait();
> +	writel(regval, ARM_RESET_REGISTER);
> +	for (i = 0; i < 64; i++) {
> +		spu_write_wait();
> +		regval = readl(SPU_REGISTER_BASE + (i * 0x80));
> +		regval = (regval & ~0x4000) | 0x8000;
> +		spu_write_wait();
> +		writel(regval, SPU_REGISTER_BASE + (i * 0x80));
> +	}
> +}
> +
> +/* spu_enable - set spu registers to enable sound output */
> +static void spu_enable(void)
> +{
> +	uint32_t regval = readl(ARM_RESET_REGISTER);
> +	regval &= ~1;
> +	spu_write_wait();
> +	writel(regval, ARM_RESET_REGISTER);
> +}
> +
> +/* 
> + * Halt the sound processor, clear the memory,
> + * load some default ARM7 code, and then restart ARM7
> +*/
> +static void spu_reset(void)
> +{
> +	spu_disable();
> +	spu_memset(0, 0, 0x200000 / 4);
> +	/* Put ARM7 in endless loop */
> +	ctrl_outl(0xea000002, SPU_MEMORY_BASE);
> +	spu_enable();
> +}
> +
> +/* aica_chn_start - write to spu to start playback */
> +static void aica_chn_start(void)
> +{
> +	spu_write_wait();
> +	writel(AICA_CMD_KICK | AICA_CMD_START, (uint32_t *) AICA_CONTROL_POINT);
> +}
> +
> +/* aica_chn_halt - write to spu to halt playback */
> +static void aica_chn_halt(void)
> +{
> +	spu_write_wait();
> +	writel(AICA_CMD_KICK | AICA_CMD_STOP, (uint32_t *) AICA_CONTROL_POINT);
> +}
> +
> +/* ALSA code below */
> +static struct snd_pcm_hardware snd_pcm_aica_playback_hw = {
> +	.info = (SNDRV_PCM_INFO_NONINTERLEAVED),
> +	.formats =
> +	    (SNDRV_PCM_FMTBIT_S8 | SNDRV_PCM_FMTBIT_S16_LE |
> +	     SNDRV_PCM_FMTBIT_IMA_ADPCM),
> +	.rates = SNDRV_PCM_RATE_8000_48000,
> +	.rate_min = 8000,
> +	.rate_max = 48000,
> +	.channels_min = 1,
> +	.channels_max = 2,
> +	.buffer_bytes_max = AICA_BUFFER_SIZE,
> +	.period_bytes_min = AICA_PERIOD_SIZE,
> +	.period_bytes_max = AICA_PERIOD_SIZE,
> +	.periods_min = AICA_PERIOD_NUMBER,
> +	.periods_max = AICA_PERIOD_NUMBER,
> +};
> +
> +static int aica_dma_transfer(int channels, int buffer_size,
> +			     struct snd_pcm_substream *substream)
> +{
> +	int q, err, period_offset;
> +	struct snd_card_aica *dreamcastcard;
> +	struct snd_pcm_runtime *runtime;
> +	err = 0;
> +	dreamcastcard = substream->pcm->private_data;
> +	period_offset = dreamcastcard->clicks;
> +	period_offset %= (AICA_PERIOD_NUMBER / channels);
> +	runtime = substream->runtime;
> +	for (q = 0; q < channels; q++) {
> +		err = dma_xfer(AICA_DMA_CHANNEL,
> +			       (unsigned long)(runtime->dma_area +
> +					       (AICA_BUFFER_SIZE * q) /
> +					       channels +
> +					       AICA_PERIOD_SIZE *
> +					       period_offset),
> +			       AICA_CHANNEL0_OFFSET + q * CHANNEL_OFFSET +
> +			       AICA_PERIOD_SIZE * period_offset,
> +			       buffer_size / channels, AICA_DMA_MODE);
> +		if (unlikely(err < 0))
> +			break;
> +		dma_wait_for_completion(AICA_DMA_CHANNEL);
> +	}
> +	return err;
> +}
> +
> +static void startup_aica(struct snd_card_aica *dreamcastcard)
> +{
> +	spu_memload(AICA_CHANNEL0_CONTROL_OFFSET,
> +		    (uint8_t *) dreamcastcard->channel,
> +		    sizeof(struct aica_channel));
> +	aica_chn_start();
> +}
> +
> +static void run_spu_dma(struct work_struct *work)
> +{
> +	int buffer_size;
> +	struct snd_pcm_substream *substream;
> +	struct snd_pcm_runtime *runtime;
> +	struct snd_card_aica *dreamcastcard;
> +	struct spu_work_holder *holder = container_of(work, struct spu_work_holder, spu_dma_work);
> +	substream = holder-> sspointer;
> +	dreamcastcard = substream->pcm->private_data;
> +	runtime = substream->runtime;
> +	if (unlikely(dreamcastcard->dma_check == 0)) {
> +		buffer_size = frames_to_bytes(runtime, runtime->buffer_size);
> +		if (runtime->channels > 1)
> +			dreamcastcard->channel->flags |= 0x01;
> +		aica_dma_transfer(runtime->channels, buffer_size, substream);
> +		startup_aica(dreamcastcard);
> +		dreamcastcard->clicks =
> +		    buffer_size / (AICA_PERIOD_SIZE * runtime->channels);
> +		return;
> +	} else {
> +		aica_dma_transfer(runtime->channels,
> +				  AICA_PERIOD_SIZE * runtime->channels,
> +				  substream);
> +		snd_pcm_period_elapsed(dreamcastcard->substream);
> +		dreamcastcard->clicks++;
> +		dreamcastcard->clicks %= AICA_PERIOD_NUMBER;
> +		mod_timer(&dreamcastcard->timer, jiffies + 1);
> +	}
> +}
> +
> +static void aica_period_elapsed(unsigned long timer_var)
> +{
> +	/*timer fuction - so cannot sleep */
> +	int play_period;
> +	struct snd_pcm_runtime *runtime;
> +	struct snd_pcm_substream *substream;
> +	struct snd_card_aica *dreamcastcard;
> +	substream = (struct snd_pcm_substream *)timer_var;
> +	runtime = substream->runtime;
> +	dreamcastcard = substream->pcm->private_data;
> +	/* Have we played out an additional period? */
> +	play_period =
> +	    frames_to_bytes(runtime,
> +			    readl
> +			    (AICA_CONTROL_CHANNEL_SAMPLE_NUMBER)) /
> +	    AICA_PERIOD_SIZE;
> +	if (play_period == dreamcastcard->current_period) {
> +		/* reschedule the timer */
> +		mod_timer(&(dreamcastcard->timer), jiffies + 1);
> +		return;
> +	}
> +	if (runtime->channels > 1)
> +		dreamcastcard->current_period = play_period;
> +	if (unlikely(dreamcastcard->dma_check == 0))
> +		dreamcastcard->dma_check = 1;
> +		queue_work(aica_queue, &(spu_working.spu_dma_work));
> +}
> +
> +static void spu_begin_dma(struct snd_pcm_substream *substream)
> +{
> +	/* Must be atomic */
> +	struct snd_card_aica *dreamcastcard;
> +	struct snd_pcm_runtime *runtime;
> +	runtime = substream->runtime;
> +	dreamcastcard = substream->pcm->private_data;
> +	/*  Use queue to do the heavy lifting */
> +	spu_working.sspointer = substream;
> +	INIT_WORK(&(spu_working.spu_dma_work), run_spu_dma);
> +	queue_work(aica_queue, &(spu_working.spu_dma_work));
> +	/* Timer may already be running */
> +	if (unlikely(dreamcastcard->timer.data)) {
> +		mod_timer(&dreamcastcard->timer, jiffies + 4);
> +		return;
> +	}
> +	init_timer(&(dreamcastcard->timer));
> +	dreamcastcard->timer.data = (unsigned long)substream;
> +	dreamcastcard->timer.function = aica_period_elapsed;
> +	dreamcastcard->timer.expires = jiffies + 4;
> +	add_timer(&(dreamcastcard->timer));
> +}
> +
> +static int snd_aicapcm_pcm_open(struct snd_pcm_substream
> +				*substream)
> +{
> +	struct snd_pcm_runtime *runtime;
> +	struct aica_channel *channel;
> +	struct snd_card_aica *dreamcastcard;
> +	if (!enable)
> +		return -ENOENT;
> +	dreamcastcard = substream->pcm->private_data;
> +	channel = kmalloc(sizeof(struct aica_channel), GFP_KERNEL);
> +	if (!channel)
> +		return -ENOMEM;
> +	/* set defaults for channel */
> +	channel->sfmt = SM_8BIT;
> +	channel->cmd = AICA_CMD_START;
> +	channel->vol = dreamcastcard->master_volume;
> +	channel->pan = 0x80;
> +	channel->pos = 0;
> +	channel->flags = 0;	/* default to mono */
> +	dreamcastcard->channel = channel;
> +	runtime = substream->runtime;
> +	runtime->hw = snd_pcm_aica_playback_hw;
> +	spu_enable();
> +	dreamcastcard->clicks = 0;
> +	dreamcastcard->current_period = 0;
> +	dreamcastcard->dma_check = 0;
> +	return 0;
> +}
> +
> +static int snd_aicapcm_pcm_close(struct snd_pcm_substream
> +				 *substream)
> +{
> +	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
> +	del_timer(&dreamcastcard->timer);
> +	kfree(dreamcastcard->channel);
> +	spu_disable();
> +	return 0;
> +}
> +
> +static int snd_aicapcm_pcm_hw_free(struct snd_pcm_substream
> +				   *substream)
> +{
> +	/* Free the DMA buffer */
> +	return snd_pcm_lib_free_pages(substream);
> +}
> +
> +static int snd_aicapcm_pcm_hw_params(struct snd_pcm_substream
> +				     *substream, struct snd_pcm_hw_params
> +				     *hw_params)
> +{
> +	/* Allocate a DMA buffer using ALSA built-ins */
> +	return
> +	    snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(hw_params));
> +}
> +
> +static int snd_aicapcm_pcm_prepare(struct snd_pcm_substream
> +				   *substream)
> +{
> +	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
> +	if ((substream->runtime)->format == SNDRV_PCM_FORMAT_S16_LE)
> +		dreamcastcard->channel->sfmt = SM_16BIT;
> +	dreamcastcard->channel->freq = substream->runtime->rate;
> +	dreamcastcard->substream = substream;
> +	return 0;
> +}
> +
> +static int snd_aicapcm_pcm_trigger(struct snd_pcm_substream
> +				   *substream, int cmd)
> +{
> +	struct snd_card_aica *dreamcastcard;
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_START:
> +		spu_begin_dma(substream);
> +		break;
> +	case SNDRV_PCM_TRIGGER_STOP:
> +		dreamcastcard = substream->pcm->private_data;
> +		if (dreamcastcard->timer.data)
> +			del_timer(&dreamcastcard->timer);
> +		aica_chn_halt();
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static unsigned long snd_aicapcm_pcm_pointer(struct snd_pcm_substream
> +					     *substream)
> +{
> +	return readl(AICA_CONTROL_CHANNEL_SAMPLE_NUMBER);
> +}
> +
> +static struct snd_pcm_ops snd_aicapcm_playback_ops = {
> +	.open = snd_aicapcm_pcm_open,
> +	.close = snd_aicapcm_pcm_close,
> +	.ioctl = snd_pcm_lib_ioctl,
> +	.hw_params = snd_aicapcm_pcm_hw_params,
> +	.hw_free = snd_aicapcm_pcm_hw_free,
> +	.prepare = snd_aicapcm_pcm_prepare,
> +	.trigger = snd_aicapcm_pcm_trigger,
> +	.pointer = snd_aicapcm_pcm_pointer,
> +};
> +
> +/* TO DO: set up to handle more than one pcm instance */
> +static int __init snd_aicapcmchip(struct snd_card_aica
> +				  *dreamcastcard, int pcm_index)
> +{
> +	struct snd_pcm *pcm;
> +	int err;
> +	/* AICA has no capture ability */
> +	err =
> +	    snd_pcm_new(dreamcastcard->card, "AICA PCM", pcm_index, 1, 0, &pcm);
> +	if (unlikely(err < 0))
> +		return err;
> +	pcm->private_data = dreamcastcard;
> +	strcpy(pcm->name, "AICA PCM");
> +	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
> +			&snd_aicapcm_playback_ops);
> +	/* Allocate the DMA buffers */
> +	err =
> +	    snd_pcm_lib_preallocate_pages_for_all(pcm,
> +						  SNDRV_DMA_TYPE_CONTINUOUS,
> +						  snd_dma_continuous_data
> +						  (GFP_KERNEL),
> +						  AICA_BUFFER_SIZE,
> +						  AICA_BUFFER_SIZE);
> +	return err;
> +}
> +
> +/* Mixer controls */
> +static int aica_pcmswitch_info(struct snd_kcontrol *kcontrol,
> +			       struct snd_ctl_elem_info *uinfo)
> +{
> +	uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
> +	uinfo->count = 1;
> +	uinfo->value.integer.min = 0;
> +	uinfo->value.integer.max = 1;
> +	return 0;
> +}
> +
> +static int aica_pcmswitch_get(struct snd_kcontrol *kcontrol,
> +			      struct snd_ctl_elem_value *ucontrol)
> +{
> +	ucontrol->value.integer.value[0] = 1;	/* TO DO: Fix me */
> +	return 0;
> +}
> +
> +static int aica_pcmswitch_put(struct snd_kcontrol *kcontrol,
> +			      struct snd_ctl_elem_value *ucontrol)
> +{
> +	if (ucontrol->value.integer.value[0] == 1)
> +		return 0;	/* TO DO: Fix me */
> +	else
> +		aica_chn_halt();
> +	return 0;
> +}
> +
> +static int aica_pcmvolume_info(struct snd_kcontrol *kcontrol,
> +			       struct snd_ctl_elem_info *uinfo)
> +{
> +	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
> +	uinfo->count = 1;
> +	uinfo->value.integer.min = 0;
> +	uinfo->value.integer.max = 0xFF;
> +	return 0;
> +}
> +
> +static int aica_pcmvolume_get(struct snd_kcontrol *kcontrol,
> +			      struct snd_ctl_elem_value *ucontrol)
> +{
> +	struct snd_card_aica *dreamcastcard;
> +	dreamcastcard = kcontrol->private_data;
> +	if (unlikely(!dreamcastcard->channel))
> +		return -ETXTBSY;	/* we've not yet been set up */
> +	ucontrol->value.integer.value[0] = dreamcastcard->channel->vol;
> +	return 0;
> +}
> +
> +static int aica_pcmvolume_put(struct snd_kcontrol *kcontrol,
> +			      struct snd_ctl_elem_value *ucontrol)
> +{
> +	struct snd_card_aica *dreamcastcard;
> +	dreamcastcard = kcontrol->private_data;
> +	if (unlikely(!dreamcastcard->channel))
> +		return -ETXTBSY;
> +	if (unlikely(dreamcastcard->channel->vol ==
> +		     ucontrol->value.integer.value[0]))
> +		return 0;
> +	dreamcastcard->channel->vol = ucontrol->value.integer.value[0];
> +	dreamcastcard->master_volume = ucontrol->value.integer.value[0];
> +	spu_memload(AICA_CHANNEL0_CONTROL_OFFSET,
> +		    (uint8_t *) dreamcastcard->channel,
> +		    sizeof(struct aica_channel));
> +
> +	return 1;
> +}
> +
> +static struct snd_kcontrol_new snd_aica_pcmswitch_control __devinitdata = {
> +	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> +	.name = "PCM Playback Switch",
> +	.index = 0,
> +	.info = aica_pcmswitch_info,
> +	.get = aica_pcmswitch_get,
> +	.put = aica_pcmswitch_put
> +};
> +
> +static struct snd_kcontrol_new snd_aica_pcmvolume_control __devinitdata = {
> +	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> +	.name = "PCM Playback Volume",
> +	.index = 0,
> +	.info = aica_pcmvolume_info,
> +	.get = aica_pcmvolume_get,
> +	.put = aica_pcmvolume_put
> +};
> +
> +static int load_aica_firmware(void)
> +{
> +	int err;
> +	const struct firmware *fw_entry;
> +	err = 0;

Useless assignment err = 0; remove.

> +	spu_reset();
> +	err = request_firmware(&fw_entry, "aica_firmware.bin", &pd->dev);
> +	if (unlikely(err))
> +		return err;
> +	/* write firware into memory */
> +	spu_disable();
> +	spu_memload(0, fw_entry->data, fw_entry->size);
> +	spu_enable();
> +	release_firmware(fw_entry);
> +	return err;
> +}
> +
> +static int __devinit add_aicamixer_controls(struct snd_card_aica
> +					    *dreamcastcard)
> +{
> +	int err;
> +	err = snd_ctl_add
> +	    (dreamcastcard->card,
> +	     snd_ctl_new1(&snd_aica_pcmvolume_control, dreamcastcard));
> +	if (unlikely(err < 0))
> +		return err;
> +	err = snd_ctl_add
> +	    (dreamcastcard->card,
> +	     snd_ctl_new1(&snd_aica_pcmswitch_control, dreamcastcard));
> +	if (unlikely(err < 0))
> +		return err;
> +	return 0;
> +}
> +
> +static int snd_aica_remove(struct platform_device *devptr)
> +{
> +	struct snd_card_aica *dreamcastcard;
> +	dreamcastcard = platform_get_drvdata(devptr);
> +	if (unlikely(!dreamcastcard))
> +		return -ENODEV;
> +	snd_card_free(dreamcastcard->card);
> +	kfree(dreamcastcard);
> +	platform_set_drvdata(devptr, NULL);
> +	return 0;
> +}
> +
> +static int __init snd_aica_probe(struct platform_device *devptr)
> +{
> +	int err;
> +	struct snd_card_aica *dreamcastcard;
> +	dreamcastcard = kmalloc(sizeof(struct snd_card_aica), GFP_KERNEL);
> +	if (unlikely(!dreamcastcard))
> +		return -ENOMEM;
> +	dreamcastcard->card =
> +	    snd_card_new(index, SND_AICA_DRIVER, THIS_MODULE, 0);
> +	if (unlikely(!dreamcastcard->card)) {
> +		kfree(dreamcastcard);
> +		return -ENODEV;
> +	}
> +	strcpy(dreamcastcard->card->driver, "snd_aica");
> +	strcpy(dreamcastcard->card->shortname, SND_AICA_DRIVER);
> +	strcpy(dreamcastcard->card->longname,
> +	       "Yamaha AICA Super Intelligent Sound Processor for SEGA Dreamcast");
> +	/* Load the PCM 'chip' */
> +	err = snd_aicapcmchip(dreamcastcard, 0);
> +	if (unlikely(err < 0))
> +		goto freedreamcast;
> +	snd_card_set_dev(dreamcastcard->card, &devptr->dev);
> +	dreamcastcard->timer.data = 0;
> +	dreamcastcard->channel = NULL;
> +	/* Add basic controls */
> +	err = add_aicamixer_controls(dreamcastcard);
> +	if (unlikely(err < 0))
> +		goto freedreamcast;
> +	/* Register the card with ALSA subsystem */
> +	err = snd_card_register(dreamcastcard->card);
> +	if (unlikely(err < 0))
> +		goto freedreamcast;
> +	platform_set_drvdata(devptr, dreamcastcard);
> +	aica_queue = create_workqueue("aica");

Use CARD_NAME instead of "aica" as you already have that defined..

> +	if (unlikely(!aica_queue))
> +		goto freedreamcast;
> +	snd_printk
> +	    ("ALSA Driver for Yamaha AICA Super Intelligent Sound Processor\n");
> +	return 0;
> +      freedreamcast:
> +	snd_card_free(dreamcastcard->card);
> +	kfree(dreamcastcard);
> +	return err;
> +}
> +
> +static struct platform_driver snd_aica_driver = {
> +	.probe = snd_aica_probe,
> +	.remove = snd_aica_remove,
> +	.driver = {
> +		   .name = SND_AICA_DRIVER},
> +};
> +
> +static int __init aica_init(void)
> +{
> +	int err;
> +	err = platform_driver_register(&snd_aica_driver);
> +	if (unlikely(err < 0))
> +		return err;
> +	pd = platform_device_register_simple(SND_AICA_DRIVER, -1,
> +					     aica_memory_space, 2);
> +	if (unlikely(IS_ERR(pd))) {
> +		platform_driver_unregister(&snd_aica_driver);
> +		return PTR_ERR(pd);
> +	}
> +	/* Load the firmware */
> +	err = load_aica_firmware();
> +	if (unlikely(err < 0))
> +		return err;
> +
> +	return 0;
> +}

return load_aica_firmware(); ?

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
